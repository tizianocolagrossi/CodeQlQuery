/**
 * @name Multistate If blocks using enum 
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id cpp/enum/ifs/multistate-blocks-w-enum-use
 */

import cpp
import modules.EnumerationsModule
import semmle.code.cpp.dataflow.new.DataFlow

from IfStmt ifs, EnumerationVariableAccess eva, Stmt multistate,
DataFlow::Node source, DataFlow::Node sink
where eva.getEnclosingStmt() = ifs

and (
    (
        allowSingleState(eva.getEnclosingElement())
        and multistate = ifs.getElse()
    )
    or(
        not allowSingleState(eva.getEnclosingElement())
        and multistate = ifs.getThen()
    )
)


and not ifs.getElse() instanceof IfStmt
and not ifs.getElse() instanceof ReturnStmt

and source.asExpr() = eva
and sink.asExpr() instanceof VariableAccess
and ifs = getAnEnclosingIfStmtOfStmt(sink.asExpr().(VariableAccess).getEnclosingStmt())
and not sink.asExpr().getEnclosingStmt() instanceof SwitchStmt
and not sink.asExpr().getEnclosingStmt() instanceof IfStmt
and DataFlow::localFlow(source, sink)

// select ifs, eva.getEnclosingElement(), multistate
select multistate, "Block of code that can be visited with multiple states of the enumeration type $@ with deps in $@", 
getEnumType(eva), 
getEnumType(eva).toString(), 
sink,
sink.toString()