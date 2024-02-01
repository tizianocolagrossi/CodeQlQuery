/**
 * @name Enumeration use witout constant that are not == or =
 * @id cpp/enumeration/use-wo-constant-not-==-=
 */

 import cpp
 import modules.EnumerationsModule

  
 from EnumerationVariableAccessConstant evac
 where evac.getEnclosingElement().toString() != "... == ..."
 and evac.getEnclosingElement().toString() != "... = ..."
 select evac, evac.getEnclosingElement(), evac.getType()