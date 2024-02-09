
/**
 * @name return stmt that return enumeration not fully compared in conditional
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id cpp/enum/return/notocnditional
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
    EnumConstant ec
    |
    ec.getAnAccess().getEnclosingElement() = eva.getTarget().getAnAccess().getEnclosingElement()
    and
    ec.getAnAccess().getEnclosingElement() instanceof ComparisonOperation
    |
    ec
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