Several simple claude code commands to make my workflow more efficient. 

The idea I'm trying to move towards roughly is:
 - try to simulate 'endless context'. Without direct access it is not that easy, however, we can simulate it partially with summarizing all the changes/findings into commit messages and restoring the relevant history. **Do not rely on auto-compact!**
 - There are two parallel streams - context/message stream in assistant and commit history in version contorl. They need to work together and utilize context saving/restoration usign version control.
 
Assumed invariants:
 - main branch has up to date user documentation (README.md, etc)
 - main branch has up to date assistant documentation (CLAUDE.md, plans, architecture, etc)
 - main branch has tests/lint passing

Commands:
 - `/commit` - commit current changes with detailed commit message, summarizing both current change and what part it plays in the larger 'feature' implementation.
 - `/hk` - housekeeping. Ask to make sure docs, todo lists are up to date and there are no huge files. Huge files are hard for assistant to read and should be refactored.
 - `/up2speed` - read recent commit messages and understand what we were working on.

Process:
 - We are still treating claude code as personal assistant, not standalone agent.
 - We are working on a single 'feature' at a time, represented by a single git branch. Switching branch would require `/up2speed`.
 - For each 'working' change, no matter how small, commit it using '/commit'. That will create a detailed summary in the commit message.
 - Once in a while, **but definitely before merging to main** call `/hk`

Multiple ways to provide instructions to the assistant:
 - First way is to just ask as text input in the assistant interface;
 - Feature-specific todo/architecture/implementation plan referenced to the assistant. The plan itself might be created manually or built with other AI, say, deep research. Being feature specific, it needs to become part of commit messages and/or persistent documentation (CLAUDE.md, etc)
 - Longer-term architecture/planning documents. These needs to be kept up to date.


Current exploration:
 - automatic `/up2speed` when switching branches
 - automatic `/hk` on commit. Seems too slow/expensive for tokens in context as we prefer to `/commit` tiny changes
 - automatic `/hk` on X% of context window left.

