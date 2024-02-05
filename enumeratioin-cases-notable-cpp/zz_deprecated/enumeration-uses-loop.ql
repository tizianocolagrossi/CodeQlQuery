/**
 * @name Loops with enumeration in conditions
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/enum-in-loop
 */

 import cpp
 import modules.EnumerationsModule


 from EnumerationVariableAccess eva, Loop l
 where eva.getEnclosingStmt() = l
 and eva.getEnclosingElement().toString() != "... == ..."
 select l, 
 "Enumeration variable '"+eva.toString()+"' type $@ used in loop", eva.getType(), eva.getType().toString()

