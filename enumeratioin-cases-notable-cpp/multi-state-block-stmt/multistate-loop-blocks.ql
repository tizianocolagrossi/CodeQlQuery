/**
 * @name Multistate If blocks
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id cpp/enum/ifs/multistate-blocks
 */

import cpp
import modules.EnumerationsModule
import semmle.code.cpp.dataflow.new.DataFlow

from Loop l, EnumerationVariableAccess eva, 
DataFlow::Node source, DataFlow::Node sink

where eva.getEnclosingStmt() = l.getCondition().getEnclosingStmt()
and not allowSingleState(eva.getEnclosingElement())

and source.asExpr() = eva
and sink.asExpr() instanceof VariableAccess
and l = getAnEnclosingLoopOfStmt(sink.asExpr().(VariableAccess).getEnclosingStmt())
and DataFlow::localFlow(source, sink)

select l, "Loop can have multiple state of enumeration $@. Deps at $@",
getEnumType(eva), 
getEnumType(eva).toString(), 
sink, 
sink.toString()