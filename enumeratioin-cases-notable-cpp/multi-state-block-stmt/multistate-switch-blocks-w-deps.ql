/**
 * @name Multistate switch with deps
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id cpp/enum/switch/multistate-blocks-dep
 */

 import cpp
 import modules.EnumerationsModule
 import semmle.code.cpp.dataflow.new.DataFlow


from EnumSwitch switch, EnumerationVariableAccess eva, Stmt multistate, int missing,
DataFlow::Node source, DataFlow::Node sink

where switch.getControllingExpr() = eva
and multistate = switch.getDefaultCase()

and source.asExpr() = eva
and sink.asExpr() instanceof VariableAccess
and switch = getAnEnclosingSwitchStmtOfStmt(sink.asExpr().(VariableAccess).getEnclosingStmt())
and DataFlow::localFlow(source, sink)
and missing = count(switch.getAMissingCase()) 
and missing > 1
select multistate, "Block with "+missing.toString()+" state possible of the enumeration $@, with dep in $@",
getEnumType(eva),
getEnumType(eva).toString(), 
sink, 
sink.toString()