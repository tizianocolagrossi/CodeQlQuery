/**
 * @name Enumeration use wo if switch
 * @id cpp/enumeration/useWOIfSwitch
 */

 import cpp
 import modules.EnumerationsModule
 
 from EnumerationVariableAccess eva
 where not exists( SwitchStmt sws | eva.getEnclosingStmt() = sws) 
 and not exists( IfStmt ifs | eva.getEnclosingStmt() = ifs) 
 select eva, eva.getType(), eva.getEnclosingElement()