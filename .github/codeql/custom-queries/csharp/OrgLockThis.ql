/**
 * @name Org rule: lock(this)
 * @description Finds lock statements that lock the public current instance.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id ms-pwc/csharp/lock-this
 * @tags reliability
 *       maintainability
 *       concurrency
 *       external/cwe/cwe-662
 */

import csharp

from LockStmt lockStatement, ThisAccess thisAccess
where thisAccess = lockStatement.getExpr()
select thisAccess, "Do not lock on 'this'. Use a private dedicated lock object to avoid externally controlled locking."
