/**
 * @name Enumeration variable access inside a loop and independent form the loop condition
 * @kind problem
 * @problem.severity warning
 * @id cpp/enum/loop-dependent
 */

 import cpp
 import modules.EnumerationsModule
 import semmle.code.cpp.dataflow.new.DataFlow
 
 from Loop l, EnumerationVariableAccess eva, DataFlow::Node source, DataFlow::Node sink
 where l.getStmt().getAChild*() = eva
 and sink.asExpr() = eva
 and source.asExpr().getEnclosingStmt() = l
 and not DataFlow::localFlow(source, sink)
 and not eva.getEnclosingStmt() instanceof SwitchStmt
 and not eva.getEnclosingStmt() instanceof IfStmt
 
 select eva, "Enumeration variable access $@ ot  type $@ independent from loop condition $@",eva, eva.toString(), eva.getType(), eva.getType().toString(), l, "loop"