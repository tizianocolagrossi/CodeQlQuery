
/**
 * @name return stmt that return enumeration not fully compared in conditional
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id cpp/enum/return/not.ocnditional
 */

import cpp
import modules.EnumerationsModule


from 
    ReturnStmt ret, 
    EnumerationVariableAccess eva, 
    int constantSizeDefined, 
    int constantSizeCmp
// select all return statement with enumeration va
where ret = eva.getEnclosingElement()
and constantSizeDefined = getNumberOfConstants(getEnumType(eva))
and constantSizeCmp = count(
    EnumConstantAccess eca,
    EnumerationVariableAccess evaInComparison
    |
    eva.getTarget() = evaInComparison.getTarget()
    and eca.getEnclosingElement() = evaInComparison.getEnclosingElement()
    and evaInComparison.getEnclosingElement() instanceof ComparisonOperation
    |
    eca
)
and constantSizeDefined > constantSizeCmp
and not exists(EnumConstantAccess eca | eca.getEnclosingElement() = ret )
select ret, 
"Return $@ of type $@ that is not fully compared in conditional with enum constants ("+constantSizeCmp.toString()+"/"+constantSizeDefined.toString()+")",
eva,
eva.toString(),
eva.getType(),
eva.getType().toString()
// select ret, eva.getType(), constantSizeDefined, constantSizeCmp