/**
 * @name Enumeration uses to access array
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/enum-uses-access-array
 */

 import cpp
 import modules.EnumerationsModule


 from EnumerationVariableAccess eva
 where eva.getEnclosingElement().toString() = "access to array"

//  select eva, eva.getType()
 select eva, 
 "Array accessed with enumeration $@", 
 eva.getType(), 
 eva.getType().toString()