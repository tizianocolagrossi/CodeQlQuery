// /**
//  * @name Amount state comp for enum variable
//  * @description Return the amount of state of the enum that where compared with enum constants
//  * @kind problem
//  * @problem.severity warning
//  * @precision low
//  * @id cpp/enum/variables/explored-in-conditions
//  */

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
    )
    |
    ec)
and cmpSingleConstantCount >= amountConstantDefined
// select v, e, constants, enumElementDecl

select v, "Variable of type $@ not fully compared with all the constant defined ("+cmpSingleConstantCount.toString()+"/"+amountConstantDefined.toString()+")",
e, 
e.toString()
// select v, e, constants, enumElementDecl


