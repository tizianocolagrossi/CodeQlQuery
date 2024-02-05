/**
 * @name Array indexed with enum not used in in ifs
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/enum-uses-access-array-not-in-ifs
 */

 import cpp
 import modules.EnumerationsModule

 // [TODO] use dataflow to discard access with constant value

 from EnumerationVariableAccess eva, ArrayExpr ae
 where eva.getEnclosingElement() instanceof ArrayExpr
 and not eva.getEnclosingStmt() instanceof IfStmt
 and ae.getArrayOffset() = eva
 select eva, "Used to index array $@",
 ae.getArrayBase(),
 ae.getArrayBase().toString()
