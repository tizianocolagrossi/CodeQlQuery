/**
 * This is an automatically generated file
 * @name All enumeration use flows from conditional to eva not visible only with cc
 * @kind problem
 * @problem.severity warning
 * @id cpp/enumeration-use-flows-from-conditional-to-eva-not-visible-to-cc
 */


    import cpp
    import modules.EnumerationsModule
    import semmle.code.cpp.dataflow.new.DataFlow
 
 module EnumerationFlowCCConf implements DataFlow::ConfigSig{
     predicate isSource(DataFlow::Node source) {
         exists(ConditionalExpr ce, ConditionalStmt cs, Loop l, EnumerationVariableAccess eva | 
             source.asExpr() = eva and ce.getEnclosingStmt() = eva.getEnclosingStmt()
             or
             source.asExpr() = eva and cs = eva.getEnclosingStmt()
             or
             source.asExpr() = eva and l.getCondition().getEnclosingStmt() = eva.getEnclosingStmt()
         )
     }
 
     predicate isSink(DataFlow::Node sink){
         exists(EnumerationVariableAccess eva | sink.asExpr() = eva)
     }
 }
 
 module EnumCCFlow = DataFlow::Global<EnumerationFlowCCConf>;
 
 from DataFlow::Node source, DataFlow::Node sink
 where EnumCCFlow::flow(source, sink) 
 and source.asExpr() != sink.asExpr()
 and 
 select source, "Enumeration data flow from $@ to $@.",source, source.toString(), sink, sink.toString()