/**
 * @name Enumeration use not constant
 * @id cpp/enumeration/useNConstant
 */

 import cpp
 import modules.EnumerationsModule

from EnumerationVariableAccess eva
where not eva instanceof EnumerationVariableAccessConstant
select eva, eva.getEnclosingElement(), eva.getType()