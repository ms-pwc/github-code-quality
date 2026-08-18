/**
 * @name Org rule: explicit garbage collection
 * @description Finds explicit GC.Collect calls that usually indicate memory-management or performance problems.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id ms-pwc/csharp/explicit-gc-collect
 * @tags reliability
 *       maintainability
 *       performance
 */

import csharp

from MethodCall call, Method collect
where
  call.getTarget() = collect and
  collect.hasName("Collect") and
  collect.getDeclaringType().hasFullyQualifiedName("System", "GC")
select call, "Avoid explicit garbage collection. Let the runtime manage collections unless this is justified by a measured operational requirement."
