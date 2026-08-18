/**
 * @name Org rule: large or complex method
 * @description Finds methods with many statements as a lightweight organization-specific maintainability guardrail.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id ms-pwc/csharp/large-method
 * @tags maintainability
 *       readability
 */

import csharp

from Method method, int statementCount
where
  statementCount = count(Stmt statement | statement.getParent*() = method.getBody()) and
  statementCount >= 20
select method, "This method contains " + statementCount.toString() + " statements. Split complex logic into smaller, focused methods."
