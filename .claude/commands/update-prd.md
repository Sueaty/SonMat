A PR or branch was just merged to main. Update the PRD if needed.

Your task:
1. Run `git log main --oneline -10` to see recent commits.
2. Run `git diff HEAD~$ARGUMENTS HEAD` to see what changed (default to 1 if no argument given).
3. Read the current `SonMat_PRD.md`.
4. Determine if the merged changes affect product behavior, screens, data model, design system, analytics, or any other section documented in the PRD.
5. If the PRD needs updating, edit `SonMat_PRD.md` to reflect the current state of the product. Only change sections that are affected. Do not rewrite unchanged sections.
6. If the PRD does NOT need updating (e.g., pure refactor, test, or infra change), say so and stop.

Rules:
- Keep the PRD platform-agnostic. Do not add iOS/Android-specific implementation details.
- Be surgical — only update what changed. Do not reorganize or reformat unrelated sections.
- If a feature was added, reflect it in the relevant screen description and user stories if applicable.
- If a data model column was added/removed, update section 7.
- If a new analytics event was added, update section 11.
- After editing, summarize what you changed and why.
