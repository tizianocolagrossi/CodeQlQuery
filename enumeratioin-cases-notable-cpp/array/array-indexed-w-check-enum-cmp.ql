/**
 * @name Array indexed with enum check in ifs
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/enum-uses-access-array-check-cmp
 */

 import cpp
 import modules.EnumerationsModule
 import semmle.code.cpp.dataflow.new.DataFlow

from 
EnumerationVariableAccess evaIndex, 
Enum e, 
int countCmpState,
int definedState
where evaIndex.getEnclosingElement() instanceof ArrayExpr
and e = getEnumType(evaIndex) 
and definedState = getNumberOfConstants(e)
and countCmpState = getAmountOfStateCompared(evaIndex.getTarget(), e)
and not evaIndex.getTarget().getParentScope() instanceof Type
and (
    evaIndex.getTarget().getParentScope().(Function).getBlock().getNumStmt() > 0
    or
    evaIndex.getTarget().getParentScope() instanceof Stmt
)
and countCmpState < definedState
// select evaIndex, e, evaIndex.getTarget(),countCmpState, definedState
select evaIndex, 
"Array accessed with enumeration $@ compared ("+countCmpState+"/"+definedState+")", 
evaIndex.getType(), 
evaIndex.getType().toString()