/**
* @kind path-problem
* @name test-path 
* @id cpp/path/enum-test
* @problem.severity warning
*/

import cpp

import semmle.code.cpp.dataflow.new.DataFlow
// import Flow::PathGraph

module EnumerationsFlowConfiguration implements DataFlow::ConfigSig {
   predicate isSource(DataFlow::Node source) {
       exists(Variable v, Enum e, TypedefType tdt | 
               source.asParameter().(Variable) = v 
               and (
                   v.getType() = e
                   or
                   (
                    v.getType() = tdt
                    and
                    tdt.getBaseType() = e
                    )
               )
           )
   }
 
   predicate isSink(DataFlow::Node sink) {
       exists(ConditionalStmt conds | 
        sink.asDefiningArgument().getEnclosingStmt() = conds)
   }
}

// module Flow = DataFlow::Global<EnumerationsFlowConfiguration>;

// from Flow::PathNode source, Flow::PathNode sink
from DataFlow::Node source, DataFlow::Node sink
// where Flow::flowPath(source, sink)
where DataFlow::localFlow(source, sink)
and exists(Variable v, Enum e, TypedefType tdt |
        source.asParameter().(Variable) = v
        and (
            v.getType() = e 
            or (
                v.getType() = tdt
                and
                tdt.getBaseType() = e)

            )
    )
and (
    exists(ConditionalExpr conde | sink.asExpr() = conde )
    or
    exists(ConditionalStmt conds | sink.asExpr().getEnclosingStmt() = conds )

) 

select source, sink.asExpr().getEnclosingStmt()
// select sink.getNode(), source, sink, 
// "Flow from Enum varable $@ type $@ to conditional statement $@!", 
// source.getNode(), source.getNode().toString(),
// source.getNode().getType(), source.getNode().getType().toString(), 
// sink.getNode(), sink.getNode().toString() 