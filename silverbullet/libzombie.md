```space-lua
--
-- One of the utilities/widgets to help keep the space clean.
-- The goal is to identify zombie pages - ones I've created and
-- haven't read in a while. This is to capture temporary notes that
-- would not bring much value and only clutter the space.
-- If a note is 'allowed' to be there and is rarely read,
-- we can add the #evergreen tag, which will skip reporting that
-- page as a zombie.
-- On every page open, we add a timestamp to the frontmatter.
-- This might seem like further clutter, but for some cases it's
-- actually beneficial, as it is stored directly in the .md file
-- and can be processed by external tools as well.
-- The widget shows a list of zombie pages that can be configured
-- for duration threshold (how long after the last read to consider
-- a page a zombie) and number of items.
--

event.listen {
  name = "editor:pageLoaded",
  run = function(pageName, previousPage)
    -- Get current page text
    local text = editor.getText()

    -- Get current timestamp (ISO 8601 format)
    local timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")

    -- Patch the frontmatter (creates section if it doesn't exist)
    local updated = index.patchFrontmatter(text, {
      {op = "set-key", path = "opened_at", value = timestamp}
    })

    -- Update the page
    editor.setText(updated)
  end
}

-- Command to find zombie pages
function findZombiePages(daysThreshold)
  -- custom tag to mark page as persistent + system tags
  local excludeTags = {"evergreen", "meta", "meta/template/page", "meta/template/slash", "meta/api"}

  -- Calculate threshold timestamp
  local nowSeconds = os.time()
  local thresholdSeconds = nowSeconds - (daysThreshold * 24 * 60 * 60)
  -- Query all pages
  local allPages = query[[
    from index.tag "page"
  ]]
  
  -- Filter zombie pages
  local zombiePages = {}
  for _, page in ipairs(allPages) do
    local isZombie = false
  
    -- Check if not opened recently (or never opened)
    if not page.opened_at then
      isZombie = true
    else
      -- Parse the ISO timestamp to compare
      local openedSeconds = parseISOTimestamp(page.opened_at)
      if openedSeconds and openedSeconds < thresholdSeconds then
        isZombie = true
      end
    end
  
    -- Exclude if has any of the exclude tags
    if isZombie and page.itags then
      for _, excludeTag in ipairs(excludeTags) do
        if table.includes(page.itags, excludeTag) then
          isZombie = false
          break
        end
      end
    end
  
    if isZombie then
      table.insert(zombiePages, page)
    end
  end
  
  -- Sort by last opened (never opened first, then oldest first)
  table.sort(zombiePages, function(a, b)
    if not a.opened_at and not b.opened_at then
      return a.name < b.name
    elseif not a.opened_at then
      return true
    elseif not b.opened_at then
      return false
    else
      return a.opened_at < b.opened_at
    end
  end)

  return zombiePages
end

-- Helper function to parse ISO 8601 timestamp to Unix seconds
function parseISOTimestamp(isoStr)
  -- Parse ISO format: 2025-01-15T10:30:45Z
  local pattern = "!(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)Z?"
  local year, month, day, hour, min, sec = string.match(isoStr, pattern)

  if not year then
    return nil
  end

  return os.time({
    year = tonumber(year),
    month = tonumber(month),
    day = tonumber(day),
    hour = tonumber(hour),
    min = tonumber(min),
    sec = tonumber(sec),
    isdst = false
  })
end

-- Format opened date for display
function formatOpenedDate(page)
  if not page.opened_at then
    return "never"
  end
  -- Make it more readable
  local openedStr = string.gsub(page.opened_at, "T", " ")
  openedStr = string.gsub(openedStr, "Z", "")
  return openedStr
end

-- Widget: Show top N zombie pages
function zombiePagesWidget(options)
  options = options or {}
  local limit = options.limit or 10
  local daysThreshold = options.daysThreshold or 7

  local zombiePages = findZombiePages(daysThreshold)

  -- Build markdown for widget
  local md = "### Zombie Pages (" .. #zombiePages .. " total)\n\n"

  if #zombiePages == 0 then
    md = md .. "No zombie pages found!\n"
  else
    md = md .. "Pages not opened in " .. daysThreshold .. " days:\n\n"

    -- Show top N
    local displayCount = math.min(limit, #zombiePages)
    for i = 1, displayCount do
      local page = zombiePages[i]
      local openedStr = formatOpenedDate(page)
      md = md .. "* [[" .. page.name .. "]] - " .. openedStr .. "\n"
    end

    if #zombiePages > limit then
      md = md .. "* ... and " .. (#zombiePages - limit) .. " more\n"
    end

    md = md .. "\nAdd `#evergreen` tag to exclude pages from this list\n"
  end

  return widget.new {
    markdown = md
  }
end

```

