/**
 * @name Amount state comp for enum variable
 * @description Return the amount of state of the enum that where compared with enum constants
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id cpp/enum/variables/explored-in-conditions
 */

import cpp
import modules.EnumerationsModule


from EnumerationVariable ev, Enum e, int cmpSingleConstantCount, int amountConstantDefined
where (e = ev.getType() or ev.getType().(TypedefType).getBaseType() = e)
and cmpSingleConstantCount = count(
                EnumConstant ec 
                | 
                ec.getAnAccess().getEnclosingElement() = ev.getAnAccess().getEnclosingElement() 
                and
                ec.getAnAccess().getEnclosingElement() instanceof ComparisonOperation
                | 
                ec
            )
and amountConstantDefined = getNumberOfConstants(e)
// select ev, e, c, getNumberOfConstants(e)
and cmpSingleConstantCount < amountConstantDefined 
select ev, "Variable or type $@ not fully compared with all the constant defined ("+cmpSingleConstantCount.toString()+"/"+amountConstantDefined.toString()+")",
e, 
e.toString()