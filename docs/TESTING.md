# Permission-change testing protocol

This protocol is for any change to who can see, create, assign, edit, complete,
or delete a task. It is intended to let a reviewer verify the change from the
user's point of view and at the HTTP boundary before approving a merge.

## 1. Start with the actual role cards and policy

Use the three Studio Lumière role cards in
[docs/dossier-de-conception.md](./dossier-de-conception.md), section 2.2:

- **Manager (`manager`, gérante):** needs an overview, creates and assigns
  tasks, and follows their completion.
- **Esthetician (`esthetician`, esthéticienne):** needs to find and complete
  her own work.
- **Receptionist (`receptionist`, réceptionniste):** needs to create tasks
  quickly and follow their status.

The role workflow and original wireframes are in section 2.3 of that document.
The role-specific screen references are
[docs/captures/manager.png](./captures/manager.png),
[docs/captures/esthetician.png](./captures/esthetician.png), and
[docs/captures/receptionist.png](./captures/receptionist.png). Test the
workflow, not just the role name: a permission change can leave a role unable
to finish its main task even if its page still loads.

Before writing or changing an assertion, state the intended policy for the
affected action, including whether it applies to *all* tasks, only assigned
tasks, or only tasks created by that user. Do not infer policy from a hidden
button or an old test alone.

### Existing behavior to verify against

The current implementation and tests establish these expectations:

| Action | Manager | Esthetician | Receptionist |
| --- | --- | --- | --- |
| View the task list | Allowed | Allowed | Allowed |
| Create a task | Allowed | Allowed | Allowed |
| Assign/reassign via `user_id` | Allowed | Not permitted by strong parameters | Not permitted by strong parameters |
| Edit any task | Allowed | No | No |
| Edit own assigned task | Allowed | Allowed | No |
| Delete a task | Allowed | No | No |

This is a baseline, not a substitute for an approved product decision.
`README.md` and `docs/DEBT.md` say a receptionist can edit her own task through
its URL, but `TasksController#require_edit_permission` and
`test/controllers/tasks_controller_test.rb` currently deny that action. If a
change touches this discrepancy, stop and get the intended policy confirmed;
then update the controller, tests, and user-facing documentation together.

Also note that `?mine=1` is a list filter, not an authorization boundary.
Changing or removing it must not grant access to a state-changing action.

## 2. Test every route at the server boundary

For each role change, build a small permission matrix before implementation.
For every affected action, exercise the HTTP request directly as each relevant
role; do not rely only on what the rendered page shows.

Check:

1. **Authentication:** an unauthenticated request is redirected to login and
   does not change data.
2. **Allowed requests:** the request succeeds and only the permitted fields
   and records change.
3. **Denied requests:** try the direct URL and the corresponding forged
   `POST`, `PATCH`/`PUT`, or `DELETE`, not just a missing link. Confirm the
   response follows the app's denial behavior and the database is unchanged.
4. **Ownership boundaries:** for esthetician permissions, cover her assigned
   task, another user's task, and an unassigned task. For any receptionist
   permission, cover the same cases if policy allows a narrower scope.
5. **Assignment and mass assignment:** submit a forged `user_id` as a
   non-manager and verify that the assignment cannot be changed. Verify
   managers can assign and unassign only as intended.
6. **Completion:** test the `PATCH` used by the “Terminer” control separately
   from editing the form. Verify both the allowed role/ownership combinations
   and denied direct requests; the button's visibility is not proof of
   authorization.
7. **Non-regression:** check that a denied request cannot alter the title,
   assignee, completion state, or record count, as applicable.
8. **Feedback:** verify the user receives a clear denial/redirect or validation
   response, rather than a successful-looking page or an unhandled exception.

The current role fixtures are `users(:Camile)` (manager),
`users(:Laurent)` (esthetician), and `users(:Nora)` (receptionist), defined in
`test/fixtures/users.yml`. Task ownership examples are in
`test/fixtures/tasks.yml`: `:gel_order`, `:late_towels`,
`:unscheduled_appointment`, and `:unassigned_task`.

## 3. Use the existing screen-critique rubric

The rubric is recorded in the “La rubrique critique d'écran” and “Critiquer
la liste des tâches” sections of [docs/journal-test.md](./journal-test.md).
For the relevant role and workflow, record:

| Role and task | What helps | What hinders or is missing | Impact / severity | Expected result and evidence |
| --- | --- | --- | --- | --- |
| Which role is doing what? | Information or control supporting the task | Confusing, missing, or incorrectly available information/control | Critical / major / minor (explain why) | Expected screen and the test, screenshot, or reproducible steps |

Review the changed screen as that role, including empty and denied states.
Confirm that controls match the policy, labels and feedback make the result
clear, and the role can complete its primary workflow. A control hidden in the
UI must still be denied if its endpoint is not allowed; a control shown in the
UI must not lead to an unauthorized mutation. Record any usability issue
separately from an authorization failure.

Use the screen examples as references, not as proof that the current UI is
correct. The journal captures observed issues and proposed changes; confirm
that a proposal is still intended before treating it as acceptance criteria.

## 4. Red-first bug rule

For every bug found while changing permissions, reproduce it with a focused
automated test **before** changing the implementation:

1. Add or adjust the smallest relevant test to express the expected secure
   behavior.
2. Run it and confirm it fails for the reported reason (**red**). If it passes,
   the test does not yet reproduce the bug; refine the setup or assertion.
3. Make the smallest implementation change that fixes the root cause.
4. Re-run the focused test and confirm it passes (**green**), then run the
   broader checks below.

Do not “fix” a permission bug by only hiding a button, weakening an assertion,
or adding a broad rescue. Preserve evidence of the denied request and
unchanged data in the regression test. If the expected policy is ambiguous,
resolve that ambiguity before encoding a test.

## 5. Run the relevant tests and CI checks

The existing focused test files for authentication and task permissions are:

- `test/controllers/tasks_controller_test.rb` — role-specific access,
  task creation, editing and deletion.
- `test/integration/user_login_test.rb` — post-login landing and the
  esthetician's “my tasks” view.
- `test/controllers/sessions_controller_test.rb` — successful and failed
  login and logout.
- `test/integration/tasks_crud_integration_test.rb` — task lifecycle and
  failed/duplicate requests.

Run the focused tests while iterating:

```sh
bin/rails test test/controllers/tasks_controller_test.rb test/integration/user_login_test.rb test/controllers/sessions_controller_test.rb test/integration/tasks_crud_integration_test.rb
```

Then run the full automated test suite used by CI:

```sh
bin/rails db:test:prepare test
```

If the change affects a rendered control or workflow, also run the system
tests:

```sh
bin/rails db:test:prepare test:system
```

Before merge, satisfy the repository CI checks in
[.github/workflows/ci.yml](../.github/workflows/ci.yml): tests, system tests,
RuboCop (`bin/rubocop -f github`), Brakeman (`bin/brakeman --no-pager`),
Bundler Audit (`bin/bundler-audit`), and the Importmap audit
(`bin/importmap audit`). Report any check that could not be run; do not
describe it as passing.

## 6. Merge checklist

- [ ] The affected role card and primary workflow are identified.
- [ ] The intended permission policy is explicit and any existing
      documentation/test conflict is resolved.
- [ ] Each relevant role has allowed and denied direct-request coverage,
      including ownership and unassigned-record cases where applicable.
- [ ] Forged parameters cannot change protected fields or assignments.
- [ ] Denied requests leave persisted data unchanged and return clear feedback.
- [ ] UI controls and empty/denied states match the server-side policy.
- [ ] The screen critique is recorded using the rubric above.
- [ ] Any bug fix followed the red-first rule and has a regression test.
- [ ] Focused tests, full tests, applicable system tests, and CI checks pass;
      unavailable checks are disclosed.
- [ ] Related role/policy documentation is updated with the implementation.