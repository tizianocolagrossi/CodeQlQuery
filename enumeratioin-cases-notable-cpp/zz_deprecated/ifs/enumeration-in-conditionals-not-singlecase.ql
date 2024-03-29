/**
 * @name Condition that can be visited with multiple values of enumeration
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/enum-condition-not-single-enum
 */

 import cpp
 import modules.EnumerationsModule


 from ConditionalStmt conds, EnumerationVariableAccess eva
 where 
 eva.getEnclosingStmt() = conds
 and(
    eva.getEnclosingElement().toString() = "... && ..."
    or eva.getEnclosingElement().toString() = "... || ..."
    or eva.getEnclosingElement().toString() = "... != ..."
    or eva.getEnclosingElement().toString() = "... <= ..."
    or eva.getEnclosingElement().toString() = "... < ..."
    or eva.getEnclosingElement().toString() = "... >= ..." 
    or eva.getEnclosingElement().toString() = "... > ..." 
    or eva.getEnclosingElement().toString() = "if (...) ..."
 )
//  select ifs, "If cond "+eva.getEnclosingElement().toString().replaceAll("...", "")+" of variable '"+eva.toString()+"' can be visited with multiple values of $@", 
//  eva.getType(), 
//  eva.getType().getName()
 select conds, "ConditionalStmt of variable '"+eva.toString()+"' can be visited with multiple values of $@", 
 eva.getType(), 
 eva.getType().getName()