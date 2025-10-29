
```space-lua
-- priority: 200

config.define("bioExportDir", {
    type = "string"
})
config.define("bioExportRules", {})

```

```space-lua
-- priority: 50
function bioTagsMatchRule(tags, rule)
  local tagged = function(tagName)
    return table.includes(tags or {}, tagName) == true
  end
  
  -- Build environment: check each tag name against the tags list
  local env = {tagged = tagged}

  -- Parse and evaluate
  local expr = spacelua.parseExpression(rule)
  local result = spacelua.evalExpression(expr, env)
  return result == true
end

function bioStripOpenedAtTag(text)
  -- Remove lines matching: opened_at: "2025-10-08T10:43:44Z" or opened_at: "!2025-10-08T10:43:44Z"
  -- This pattern matches the line including the newline
  return string.gsub(text, "opened_at:%s*\"!?%d%d%d%d%-%d%d%-%d%dT%d%d:%d%d:%d%dZ?\"\n?", "")
end

function bioPagesMatchingRule(rule)
  local pagesToExport = query[[
    from index.tag "page"
    where not table.includes(_.tags or {}, "meta")
      and not table.includes(_.tags or {}, "meta/template/page")
      and not table.includes(_.tags or {}, "meta/template/slash")
      and not table.includes(_.tags or {}, "meta/api")
      and _.name != 'index'
      and _.name != 'CONFIG'
    order by _.name
  ]]

  local allPages = {}
  for _, page in ipairs(pagesToExport) do
    if bioTagsMatchRule(page.tags, rule) then
      local pageText = space.readPage(page.name)
      local rendered = spacelua.interpolate(pageText)
      local rendered = bioStripOpenedAtTag(rendered)
      local formattedPage = "=====\n" .. page.name .. "\n\n" .. rendered .. "\n\n"
      table.insert(allPages, formattedPage)
    end
  end 

  return table.concat(allPages) .. "====="
end

-- function to export rendered content to a single file
function bioExportByRule(rule_name, content)
  local exportDir = config.get("bioExportDir")
  -- TODO: check that it is defined
  -- Create directory
  local mkdirResult = shell.run("mkdir", {"-p", exportDir})
  
  if mkdirResult.code ~= 0 then
    editor.flashNotification("bio: failed to create dir - " .. mkdirResult.stderr)
    return
  end
  
  -- Write content via stdin
  -- TODO: we need to check if content has changed.
  local fileName = exportDir .. "/" .. rule_name
  local fileNameTmp = fileName .. ".tmp"
  
  local writeResult = shell.run("tee", {fileNameTmp}, content)
  if writeResult.code ~= 0 then
    editor.flashNotification("bio: failed to write to temporary file - " .. writeResult.stderr)
    return
  end

  local cmpResult = shell.run("cmp", {fileName, fileNameTmp})
  if cmpResult.code == 0 then
    editor.flashNotification("bio: file not changed, skip writing")
    return
  end

  local writeResult = shell.run("tee", {fileName}, content)
  if writeResult.code == 0 then
    editor.flashNotification("bio: export " .. rule_name .. " [" ..  string.len(content) .."]")
  else
    editor.flashNotification("bio: write failed - " .. writeResult.stderr)
  end
end

function bioProcessUpdate(fileName)
  -- Only notify for page files (markdown files)
  if not string.endsWith(fileName, ".md") then
    return
  end

  -- Remove .md extension to get page name
  local pageName = string.sub(fileName, 1, -4)

  -- Query the page object from the index
  local pages = query[[
    from index.tag "page"
    where _.name == pageName]]
  
  if #pages != 1 then
    print('page ' .. pageName .. ' not found')
    return
  end

  local rules = config.get("bioExportRules", {})

  -- for all rules check if the rule matches the changed page
  -- if yes, export by that rule
  for _, rule in ipairs(rules) do
    print("checking bio rule: ", rule[1], rule[2])
    if bioTagsMatchRule(pages[1].tags, rule[2]) then
      print(pageName .. " matches " .. rule[1])
      local content = bioPagesMatchingRule(rule[2])
      bioExportByRule(rule[1], content)
    end
  end
end

event.listen {
  name = "file:changed",
  run = function(e)
    local fileName = e.data[1]
    print(fileName)
    print("File changed: " .. fileName)
    bioProcessUpdate(fileName)
  end
}

```


These are unit tests which can be run with the command defined.

```space-lua
-- priority: 10

function testBioTagsMatchRule()
  local tests = {
    -- {name, tags, rule, expected}
    {"Single tag match", {"work"}, "tagged('work')", true},
    {"Single tag no match", {"personal"}, "tagged('work')", false},
    {"AND both present", {"work", "active"}, "tagged('work') and tagged('active')", true},
    {"AND one missing", {"work"}, "tagged('work') and tagged('active')", false},
    {"NOT absent", {"work"}, "tagged('work') and not tagged('archived')", true},
    {"NOT present", {"work", "archived"}, "tagged('work') and not tagged('archived')", false},
    {"OR first match", {"work"}, "tagged('work') or tagged('personal')", true},
    {"OR second match", {"personal"}, "tagged('work') or tagged('personal')", true},
    {"OR neither match", {"other"}, "tagged('work') or tagged('personal')", false},
    {"Complex parens", {"work", "active"}, "(tagged('work') or tagged('personal')) and tagged('active')", true},
    {"Complex negation", {"work"}, "tagged('work') and not (tagged('archived') or tagged('deleted'))", true},
    {"Empty tags", {}, "tagged('work')", false},
    {"Empty tags NOT", {}, "not tagged('work')", true},
  }
  
  local passed = 0
  local failed = 0
  
  for _, testCase in ipairs(tests) do
    local name, tags, rule, expected = testCase[1], testCase[2], testCase[3], testCase[4]
    local result = bioTagsMatchRule(tags, rule)
    
    if result == expected then
      passed = passed + 1
      print("[ OK ] " .. name)
    else
      failed = failed + 1
      print("[FAIL] " .. name)
      print("  Rule: " .. rule)
      print("  Tags: {" .. table.concat(tags, ", ") .. "}")
      print("  Expected: " .. tostring(expected) .. ", Got: " .. tostring(result))
    end
  end
  
  print(passed .. "/" .. (passed + failed) .. " tests passed")
  
  if failed == 0 then
    editor.flashNotification("[ OK ] " .. passed .. " tests passed!")
  else
    editor.flashNotification("[FAIL] " .. failed .. " tests failed")
  end
  
  return failed == 0
end

command.define {
  name = "Bio: Test Tag Matcher",
  run = function()
    testBioTagsMatchRule()
  end
}
```
