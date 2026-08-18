/**
 * @name Org rule: empty catch block
 * @description Finds catch clauses that swallow exceptions without handling, logging, or documenting the reason.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id ms-pwc/csharp/empty-catch-block
 * @tags reliability
 *       maintainability
 *       error-handling
 *       external/cwe/cwe-390
 */

import csharp

from CatchClause catchClause
where
  catchClause.getBlock().isEmpty() and
  not exists(CommentBlock comment | comment.getParent() = catchClause.getBlock())
select catchClause, "Do not swallow exceptions silently. Handle, log, rethrow, or document why ignoring the exception is safe."
