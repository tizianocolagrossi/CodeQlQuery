/**
 * @name Enumeration uses to access array
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/enum-uses-access-array
 */

 import cpp
 import modules.EnumerationsModule

 // [TODO] use dataflow to discard access with constant value

 from EnumerationVariableAccess eva
 where eva.getEnclosingElement().toString() = "access to array"

 select eva, 
 "Array accessed with enumeration $@", 
 eva.getType(), 
 eva.getType().toString()