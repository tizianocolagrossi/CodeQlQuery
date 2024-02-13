/**
 * @name Enum uses not constant and not check in upper if, switch or loop
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id cpp/enum/uses/not-constant-not-checked-upper
 */

import cpp
import modules.EnumerationsModule

from EnumerationVariableAccess eva, Enum e

where
e = getEnumType(eva) 
and not exists(IfStmt ifs | eva.getEnclosingStmt() = ifs )
and not exists(SwitchStmt switch | eva.getEnclosingStmt() = switch )
and not exists(Loop l | eva.getEnclosingStmt() = l )

and not exists(EnumConstantAccess eca | eca.getEnclosingStmt() = eva.getEnclosingStmt() )
and not exists(IfStmt ifs, EnumerationVariableAccess evaInCondition 
    |  getEnumType(evaInCondition) = e 
    and evaInCondition.getEnclosingStmt() = ifs
    and ifs = getAnEnclosingIfStmtOfStmt(eva.getEnclosingStmt())
)
and not exists(EnumSwitch switch, EnumerationVariableAccess evaInCondition 
    |  getEnumType(evaInCondition) = e 
    and evaInCondition.getEnclosingStmt() = switch
    and switch = getAnEnclosingSwitchStmtOfStmt(eva.getEnclosingStmt())
)
and not exists(Loop l, EnumerationVariableAccess evaInCondition 
    |  getEnumType(evaInCondition) = e 
    and evaInCondition.getEnclosingStmt() = l
    and l = getAnEnclosingLoopOfStmt(eva.getEnclosingStmt())
)
select eva, "Use of variable enumeration type $@ that do not depend from a condition in if, switch and loop", 
e, e.toString()