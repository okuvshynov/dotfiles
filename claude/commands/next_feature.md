Let's start working on the next task.

1. If the content of <task></task> tag is empty, lookup for exiting tasks in plan.md, todo.md files and pick one. If the content is not empty, use that task.
2. Verify you are on main git branch. If not, ask user input. If yes, create new branch with name relevant to a task you picked.
3. Verify that tests are passing before you made any changes.
4. Follow partial TDD - come up with a plan to validate the changes once they are made. That might include creating a new test case or running the app with different set of parameters, inputs, etc.
5. Implement the tests needed to validate the change.
6. Implement the task itself.
7. Run the validation step. If failed, do extra review and go back to fixing.
8. After all validation steps are passing, do extra review to verify that all new code is well tested. If not, implement more tests (back to step 5)
9. Run entire test suite to check for regressions. If there are regressions, go back to step 4 and work on a fix.
10. After all is succeeded, run /commit command.

<task>$ARGUMENTS</task>
