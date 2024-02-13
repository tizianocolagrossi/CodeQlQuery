
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
    Enum e,
    int constantSizeDefined, 
    int constantSizeCmp
// select all return statement with enumeration va
where ret = eva.getEnclosingElement()
and e = getEnumType(eva)
and constantSizeDefined = getNumberOfConstants(e)
and constantSizeCmp = count(
    EnumConstant ec
    |
    exists(
        EnumConstantAccess eca, 
        VariableAccess va
        |
        ec = eca.getTarget()
        and
        e.getAnEnumConstant() = ec
        and 
        va.getTarget() = eva.getTarget()
        and
        va.getEnclosingElement() = eca.getEnclosingElement()
        and
        va != eca 
        and
        va.getEnclosingElement() instanceof ComparisonOperation
    )or(
        exists(
        EnumConstantAccess eca,
        VariableAccess va,
        EnumSwitch es
        |
        va.getTarget() = eva.getTarget()
        and
        va = es.getExpr()
        and
        es.getASwitchCase().getExpr() = eca
        and 
        ec = eca.getTarget()
        and
        e.getAnEnumConstant() = ec
    ))
    |
    ec)
and constantSizeDefined > constantSizeCmp
and not exists(EnumConstantAccess eca | eca.getEnclosingElement() = ret )
select ret, 
"Return $@ of type $@ that is not fully compared in conditional with enum constants ("+constantSizeCmp.toString()+"/"+constantSizeDefined.toString()+")",
eva,
eva.toString(),
eva.getType(),
eva.getType().toString()
// select ret, eva.getType(), constantSizeDefined, constantSizeCmp