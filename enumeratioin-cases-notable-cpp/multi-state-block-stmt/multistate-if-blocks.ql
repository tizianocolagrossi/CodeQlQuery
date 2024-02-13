/**
 * @name Multistate If blocks
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id cpp/enum/ifs/multistate-blocks
 */

import cpp
import modules.EnumerationsModule

from IfStmt ifs, EnumerationVariableAccess eva, Stmt multistate
where eva.getEnclosingStmt() = ifs

and (
    (
        allowSingleState(eva.getEnclosingElement())
        and multistate = ifs.getElse()
    )
    or(
        not allowSingleState(eva.getEnclosingElement())
        and multistate = ifs.getThen()
    )
)


and not ifs.getElse() instanceof IfStmt
and not ifs.getElse() instanceof ReturnStmt
// select ifs, eva.getEnclosingElement(), multistate
select multistate, "Block of code that can be visited with multiple states of the enumeration type $@", 
getEnumType(eva), 
getEnumType(eva).toString() 