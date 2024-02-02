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
      DataFlow::Node sink,
      string conditionalThenOrElse
 where 
 eva.getEnclosingStmt() = conds
 and
 (
    (
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
    and conditionalThenOrElse = "then"
 )
 or(
    //      // [TODO] add if single state to check and follow if they have and else statement
    conds instanceof IfStmt
    and(
        eva.getEnclosingElement().toString() = "... == ..."
        or eva.getEnclosingElement().toString() = "! ..."
    )    
    and conds.(IfStmt).getElse().(BlockStmt) = bs // here only else
    and source.asExpr() = eva.(Expr) 
    and sink.asExpr().getEnclosingBlock().getParentStmt*().(BlockStmt) = bs
    and DataFlow::localFlow(source, sink)
    and conditionalThenOrElse = "else"

    // [TODO] remove cases on which variable accessed is used in another if and 
    //        is unique case

 )


 select conds, "ConditionalStmt "+conditionalThenOrElse+" of variable '"+eva.toString()+"' can be visited with multiple values of $@ and the inner $@ of the conditional is dependent on the variable", 
 eva.getType(), 
 eva.getType().getName(),
 bs, 
 "block"