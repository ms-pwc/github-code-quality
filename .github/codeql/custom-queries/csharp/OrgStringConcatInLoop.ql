/**
 * @name Org rule: string concatenation in loop
 * @description Finds string concatenation performed inside loops.
 * @kind problem
 * @problem.severity recommendation
 * @precision very-high
 * @id ms-pwc/csharp/string-concat-in-loop
 * @tags reliability
 *       maintainability
 *       performance
 */

import csharp

class StringConcat extends AddExpr {
  StringConcat() { this.getType() instanceof StringType }
}

predicate stringConcatContains(StringConcat expr, Expr child) {
  child = expr or
  stringConcatContains(expr, child.getParent())
}

predicate isSelfConcatAssignExpr(AssignExpr expr, Variable variable) {
  exists(VariableAccess use |
    stringConcatContains(expr.getRightOperand(), use) and
    use.getTarget() = expr.getTargetVariable() and
    variable = use.getTarget()
  )
}

predicate isConcatExpr(AssignAddExpr expr, Variable variable) {
  expr.getLeftOperand().getType() instanceof StringType and
  variable = expr.getTargetVariable()
}

from Expr expr
where
  exists(LoopStmt loop, Variable variable |
    expr.getEnclosingStmt().getParent*() = loop and
    (isSelfConcatAssignExpr(expr, variable) or isConcatExpr(expr, variable)) and
    forall(LocalVariableDeclExpr declaration |
      declaration.getVariable() = variable |
      not declaration.getParent*() = loop
    )
  )
select expr, "Avoid repeated string concatenation in loops. Use StringBuilder or accumulate values and join them."
