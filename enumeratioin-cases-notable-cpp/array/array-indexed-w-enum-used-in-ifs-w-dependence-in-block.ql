/**
 * @name If stmt that use result of access array with enum with deps in block
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/enum-uses-access-array-in-ifs-with-deps-in-block
 */

 import cpp
 import modules.EnumerationsModule
 import semmle.code.cpp.dataflow.new.DataFlow

 // [TODO] use dataflow to discard access with constant value

 from EnumerationVariableAccess eva, 
 IfStmt ifs, 
 ArrayExpr ae,
 DataFlow::Node source, 
 DataFlow::Node sink
 
 where eva.getEnclosingElement() instanceof ArrayExpr
 and eva.getEnclosingStmt() = ifs
 and ae.getArrayOffset() = eva
 and source.asExpr() = ae
 and( 
    sink.asExpr().getEnclosingStmt().getEnclosingBlock*() = ifs.getThen()
    or sink.asExpr().getEnclosingStmt().getEnclosingBlock*() = ifs.getElse()
 )
 and DataFlow::localFlow(source, sink)
 select eva, 
 "If with access to array $@ with enum $@ of type $@ in $@", 
 ae,
 ae.getArrayBase().toString(),
 eva, 
 eva.toString(),
 eva.getType(), 
 eva.getType().toString(),
 ifs, 
 "if"