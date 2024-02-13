/**
 * @name Array indexed with enum not used in in ifs
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/enum-uses-access-array-not-in-ifs
 */

 import cpp
 import modules.EnumerationsModule
 import semmle.code.cpp.dataflow.new.DataFlow

 // [TODO] use dataflow to discard access with constant value

 from EnumerationVariableAccess eva, 
 ArrayExpr ae,
 DataFlow::Node source, 
 DataFlow::Node sink

 where eva.getEnclosingElement() instanceof ArrayExpr
 and not eva.getEnclosingStmt() instanceof IfStmt
 and ae.getArrayOffset() = eva
 and sink.asExpr() = ae
 and source.asExpr().getEnclosingStmt() instanceof IfStmt
 and( 
    sink.asExpr().getEnclosingStmt().getEnclosingBlock*() = source.asExpr().getEnclosingStmt().(IfStmt).getThen()
    or sink.asExpr().getEnclosingStmt().getEnclosingBlock*() = source.asExpr().getEnclosingStmt().(IfStmt).getElse()
 )
 and not DataFlow::localFlow(source, sink)
 select eva, "Enum $@ w type $@ used to index array not used in IfStmt $@",
 eva,
 eva.toString(),
 eva.getType(),
 eva.getType().toString(),
 ae.getArrayBase(),
 ae.getArrayBase().toString()
