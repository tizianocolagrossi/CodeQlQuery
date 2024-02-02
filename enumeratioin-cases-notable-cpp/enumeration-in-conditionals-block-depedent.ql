/**
 * @description Condition that can be visited with multiple values of enumeration and inner block dependent on enumeration
 * @name conditional not single true block dependent
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/enum-condition-not-single-enum
 */

 import cpp
 import modules.EnumerationsModule
 import semmle.code.cpp.dataflow.new.DataFlow

 from ConditionalStmt conds, 
      EnumerationVariableAccess eva, 
      BlockStmt bs, 
      DataFlow::Node source, 
      DataFlow::Node sink
 where 
 eva.getEnclosingStmt() = conds
 and(
    eva.getEnclosingElement().toString() = "... && ..."
    or eva.getEnclosingElement().toString() = "... || ..."
    or eva.getEnclosingElement().toString() = "... != ..."
    or eva.getEnclosingElement().toString() = "... <= ..."
    or eva.getEnclosingElement().toString() = "... < ..."
    or eva.getEnclosingElement().toString() = "... >= ..." 
    or eva.getEnclosingElement().toString() = "... > ..." 
    or eva.getEnclosingElement().toString() = "if (...) ..."
 )
 and conds.getAChild().(BlockStmt) = bs
 and source.asExpr() = eva.(Expr)
 and sink.asExpr().getEnclosingBlock().getParentStmt*().(BlockStmt) = bs
 and DataFlow::localFlow(source, sink)


 select conds, "ConditionalStmt of variable '"+eva.toString()+"' can be visited with multiple values of $@ and the innerblock of the conditional is dependent on the variable", 
 eva.getType(), 
 eva.getType().getName()