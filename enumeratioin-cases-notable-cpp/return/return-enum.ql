
/**
 * @name return stmt that return enumeration
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id cpp/enum/return/not.if
 */
import cpp
import modules.EnumerationsModule

from ReturnStmt ret, EnumerationVariableAccess eva
where ret = eva.getEnclosingElement()
// and not exists(IfStmt ifs, 
//     EnumerationVariableAccess evaInCondition |
//     evaInCondition.getEnclosingStmt() = ifs
//     and 
//     allowSingleState(eva.getEnclosingElement())
//     and 
//     evaInCondition.getTarget() = eva.getTarget()
// )
select ret, 
"Return $@ of type $@",
eva,
eva.toString(),
eva.getType(),
eva.getType().toString()