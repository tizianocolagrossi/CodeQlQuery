/**
 * @name Use Multistate test
 * @kind problem
 * @problem.severity warning
 * @id cpp/example/use-multistate
 */


import cpp
import semmle.code.cpp.ir.IR
import modules.EnumerationsModule
import semmle.code.cpp.dataflow.new.DataFlow

predicate allowMultistateCustom(Expr condition) {
    condition instanceof VariableAccess 
    or condition.toString() = "... != ..." 
    or condition.toString() = "... && ..." 
    or condition.toString() = "... || ..." 
    or condition.toString() = "... <= ..." 
    or condition.toString() = "... < ..." 
    or condition.toString() = "... >= ..." 
    or condition.toString() = "... > ..." 
    // or condition.toString() = "... >> ..." 
    // or condition.toString() = "... << ..."
    or condition.toString() = "& ..."  
    or condition.toString() = "access to array"

}

from Expr condition, 
Stmt conditionStmt, 
ConditionalStmt cs,
ConditionalExpr ce,
Loop l,
EnumerationVariableAccess eva 
where conditionStmt = condition.getEnclosingStmt()
and conditionStmt = eva.getEnclosingStmt()
and (
    condition = ce.getCondition() or
    condition = l.getCondition() or
    (cs instanceof IfStmt and 
        condition = cs.(IfStmt).getCondition()) or
    (cs instanceof SwitchStmt and
        condition = cs.(SwitchStmt).getControllingExpr())
)
and (allowMultistateCustom(eva.getEnclosingElement()) or
        (
            eva.getEnclosingElement().toString() = "... & ..." and
            allowMultistateCustom(eva.getEnclosingElement().getEnclosingElement())
        )
    ) 

select conditionStmt, "Meet condition that use EVA $@, type $@ w multistate block",
eva,
eva.toString(),
eva.getType(),
eva.getType().toString()