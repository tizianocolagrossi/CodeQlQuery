/**
* @id cpp/enum/arrayaccess/path
* @kind path-problem
* @problem.severity warning
*/

module ArrayEnumAccessFlowConf implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
        source.asExpr() instanceof ArrayExpr and
        exists(EnumerationVariableAccess eva | source.asExpr().(ArrayExpr).getArrayOffset() = eva )
    }
  
    predicate isSink(DataFlow::Node sink) {
        sink.asExpr() instanceof Expr
    }
}

module EnumArrayFlow = DataFlow::Global<ArrayEnumAccessFlowConf>;
import EnumArrayFlow::PathGraph

import cpp
import modules.EnumerationsModule
import semmle.code.cpp.dataflow.new.DataFlow

// LOCAL
// from ArrayExpr ae, DataFlow::Node source, DataFlow::Node sink
// where exists(EnumerationVariableAccess eva | ae.getArrayOffset() = eva )
// and source.asExpr() = ae
// and source != sink
// and DataFlow::localFlow(source, sink)
// select ae, ae.getArrayOffset(), sink

// GLOBAL
from EnumArrayFlow::PathNode source, EnumArrayFlow::PathNode sink
where EnumArrayFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Enumeration $@ of type &@ used to acess array $@. Following data paths",
source.getNode().asExpr().(ArrayExpr).getArrayOffset(),
source.getNode().asExpr().(ArrayExpr).getArrayOffset().toString(),
source.getNode().asExpr().(ArrayExpr).getArrayOffset().getType(),
source.getNode().asExpr().(ArrayExpr).getArrayOffset().getType().toString(),
source.getNode().asExpr(),
source.getNode().asExpr().toString()