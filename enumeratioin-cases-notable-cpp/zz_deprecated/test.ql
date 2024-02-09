
import cpp
import modules.EnumerationsModule

from 
    Variable v,
    Enum e, 
    int constantSizeDefined, 
    int constantSizeCmp

where (
    v.getType() = e 
    or
    v.getType().(TypedefType).getBaseType() = e
)and constantSizeDefined = getNumberOfConstants(e)
and constantSizeCmp = count(
    EnumConstantAccess eca,
    EnumConstant ec,
    EnumerationVariableAccess evaInComparison,
    string value
    |
    v = evaInComparison.getTarget()
    and eca.getEnclosingElement() = evaInComparison.getEnclosingElement()
    and evaInComparison.getEnclosingElement() instanceof ComparisonOperation
    and eca.getEnclosingElement() instanceof ComparisonOperation
    and ec = eca.getTarget()
    and ec.getDeclaringEnum() = e
    and value = ec.getValue()
    |
    value
)

and not v instanceof MemberVariable
select v, constantSizeCmp, constantSizeDefined