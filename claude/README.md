### Several simple claude code commands to make my workflow more efficient.

The idea I'm trying to move towards roughly is:
 - try to simulate 'endless context'. Without direct access it is not that easy, however, we can simulate it partially with summarizing all the changes/findings into commit messages and restoring the relevant history. **Do not rely on auto-compact!**
 - There are two parallel streams - context/message stream in assistant and commit history in version control. They need to work together and utilize context saving/restoration usign version control.
 - Current scope is 'single engineer working with assistant'. We assume that broader, team/organization level engineering process (Agile, etc.) is external. 
 - In the longer term, the question is: how do SWE process and coding assistant ecosystem should evolve together? How does a team/organization of engineers should work effectively with coding agents? Both of these things can and will change.

Process:
 - We are still treating Claude Code as personal assistant, not standalone agent.
 - We are working on a single 'feature' at a time, represented by a single git branch. Switching branch would require `/up2speed`.
 - For each 'working' change, no matter how small, commit it using '/commit'. That will create a detailed summary in the commit message.
 - Once in a while, **but definitely before merging to main** call `/hk`

Assumed invariants:
 - main branch has up to date user documentation (README.md, etc)
 - main branch has up to date assistant documentation (CLAUDE.md, plans, architecture, etc)
 - main branch has tests/lint passing
 - we must have enough information somewhere (commit messages, documentation) to easily afford losing all the context in assistant history 

Commands:
 - `/commit` - commit current changes with detailed commit message, summarizing both current change and what part it plays in the larger 'feature' implementation.
 - `/hk` - housekeeping. Ask to make sure docs, todo lists are up to date and there are no huge files. Huge files are hard for assistant to read and should be refactored.
 - `/up2speed` - read recent commit messages and documentation and understand what we were working on. Typically run after assistant restart and/or branch switch.

Multiple ways to provide instructions to the assistant:
 - First way is to just ask as text input in the assistant interface;
 - Feature-specific todo/architecture/implementation plan referenced to the assistant. The plan itself might be created manually or built with other AI, say, deep research. Being feature specific, it needs to become part of commit messages and/or persistent documentation (CLAUDE.md, etc)
 - Longer-term architecture/planning documents. These needs to be kept up to date.

Current exploration:
 - automatic `/up2speed` when switching branches
 - automatic `/hk` on commit. Seems too slow/expensive for tokens in context as we prefer to `/commit` tiny changes
 - automatic `/hk` on X% of context window left.
 - how should PR review work
 - how do we make interaction between 'planning agent' (for example, deep research from any major provider) bidirectional and more efficient? How can we make our code accesible by deep research tool, and how do we make deep research output available for agent? Should there be an MCP server exposing 'Deep Research'?
 - how can I utilize local models better? I can run them all the time without incurring API calls/token limits.
