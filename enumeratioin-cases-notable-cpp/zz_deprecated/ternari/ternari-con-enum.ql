import cpp
import modules.EnumerationsModule

from 
EnumerationVariableAccess eva, 
ConditionalExpr ce, 
Expr t, 
Expr e, 
Enum enum,
string el1,
string el2,
string el3

where ce = eva.getEnclosingElement()
and ce.getThen() = t and ce.getElse() = e
and enum = getEnumType(eva)
and ((
    el1="enum" and 
    (
        (ce.getChild(0).getType() instanceof Enum)
        or
        (ce.getChild(0).getType().(TypedefType).getBaseType() instanceof Enum)
    ))or(el1 = "no"))
and ((
    el2="enum" and 
    (
        (ce.getChild(1).getType() instanceof Enum)
        or
        (ce.getChild(1).getType().(TypedefType).getBaseType() instanceof Enum)
    ))or(el2 = "no"))
and ((
    el3="enum" and 
    (
        (ce.getChild(2).getType() instanceof Enum)
        or
        (ce.getChild(2).getType().(TypedefType).getBaseType() instanceof Enum)
    ))or(el3 = "no"))
// and not t.isConstant() 
// and not e.isConstant()


select ce, eva, enum, ce.getChild(0),el1,ce.getChild(1),el2,ce.getChild(2),el3