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
 
 from EnumIfStmtMultistate eim, DataFlow::Node source, DataFlow::Node sink
 
 where source.asExpr() = eim.getEVA()
 and sink.asExpr() instanceof EnumerationVariableAccess
 and sink.asExpr().getEnclosingStmt().getEnclosingBlock*() = eim.getMultiStateBlockStmt()
 and source.asExpr().getEnclosingStmt() != sink.asExpr().getEnclosingStmt()
 and not sink.asExpr().getEnclosingStmt() instanceof SwitchStmt
 and not sink.asExpr().getEnclosingStmt() instanceof IfStmt
 and DataFlow::localFlow(source, sink)
 select eim, "ConditionalStmt of variable '"+eim.getEVA().toString()+"' can be visited with multiple values of $@ and in the inner $@ of the conditional the variable $@ is dependent from the enumeration", 
 eim.getEVA().getType(), 
 eim.getEVA().getType().getName(),
 eim.getMultiStateBlockStmt(),
 "block",
 sink,
 sink.toString() 