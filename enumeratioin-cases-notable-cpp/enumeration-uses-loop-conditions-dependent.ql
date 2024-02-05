/**
 * @name Enumeration variable access inside a loop dependent form the loop
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
and DataFlow::localFlow(source, sink)

select eva, "Enumeration variable access $@ of type $@ dependent from $@",eva ,eva.toString(), eva.getType(), eva.getType().toString(), l.getCondition(), "loop"