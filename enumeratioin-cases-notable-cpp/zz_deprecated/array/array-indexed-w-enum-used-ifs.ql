/**
 * @name If stmt that use result of access array with enum
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/enum-uses-access-array-in-ifs
 */

 import cpp
 import modules.EnumerationsModule

 // [TODO] use dataflow to discard access with constant value

 from EnumerationVariableAccess eva, IfStmt ifs, ArrayExpr ae
 where eva.getEnclosingElement() instanceof ArrayExpr
 and eva.getEnclosingStmt() = ifs
 and ae.getArrayOffset() = eva
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