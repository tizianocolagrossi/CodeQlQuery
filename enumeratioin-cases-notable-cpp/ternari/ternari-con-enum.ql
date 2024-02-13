import cpp
import modules.EnumerationsModule

from 
EnumerationVariableAccess eva, 
ConditionalExpr ce, 
Expr t, 
Expr e
where ce = eva.getEnclosingElement()
and ce.getThen() = t and ce.getElse() = e
and not t.isConstant() 
and not e.isConstant()
select ce, eva