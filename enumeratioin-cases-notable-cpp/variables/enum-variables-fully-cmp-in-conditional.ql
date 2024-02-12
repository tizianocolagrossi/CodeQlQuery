/**
 * @name Amount state comp for enum variable fully
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id cpp/enum/variables/fully-explored-in-conditions
 */

import cpp
// import modules.EnumerationsModule

from Variable v, Enum e, int amountConstantDefined, int cmpSingleConstantCount
where (v.getType() = e or v.getType().(TypedefType).getBaseType() = e)
and amountConstantDefined = count(EnumConstant ec| e.getAnEnumConstant() = ec| ec)
and cmpSingleConstantCount = count(
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
        va.getTarget() = v
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
        va.getTarget() = v
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
and cmpSingleConstantCount >= amountConstantDefined
and not v.getParentScope() instanceof Type
and (
    v.getParentScope().(Function).getBlock().getNumStmt() > 0
    or
    v.getParentScope() instanceof Stmt
)
// select v,v.getParentScope(), e, cmpSingleConstantCount, amountConstantDefined
select v, "Variable of type $@ fully compared with all the constant defined ("+cmpSingleConstantCount.toString()+"/"+amountConstantDefined.toString()+")",
e, 
e.toString()
// select v, e, constants, enumElementDecl


