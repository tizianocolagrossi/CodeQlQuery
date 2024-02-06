
import cpp
import modules.EnumerationsModule
import semmle.code.cpp.dataflow.new.DataFlow

predicate allowSingleState(Expr x) {
    (
        x.toString() = "... == ..."
        and exists( EnumerationVariableAccessConstant evac | 
            evac.getEnclosingElement() = x
        )
    ) 
    or x.toString() = "! ..." 
    or (
        (
            x.toString() = "... & ..." 
            or x.toString() = "... >> ..." 
            or x.toString() = "... << ..."
            or x.toString() = "... + ..."
            or x.toString() = "... - ..."
            // [TODO] check below tostring 
            or x.toString() = "... --"
            or x.toString() = "... ++"
            or x.toString() = "-- ..."
            or x.toString() = "++ ..."
        )
        and allowSingleState(x.getEnclosingElement())
    )
}

// true if the eva in input is inside a switch case that 
// allow only single enumeration state
predicate evaIsSingleStateInSwitchCase(EnumerationVariableAccess eva){
    exists( EnumSwitch es, 
            SwitchCase sc, 
            EnumerationVariableAccess evaInCondition,
            Stmt innerStmt, 
            DataFlow::Node source,
            DataFlow::Node sink|  

            es.getASwitchCase() = sc
            and sc.toString() != "default: "
            and innerStmt = sc.getAStmt*()
            and innerStmt != sc
            and evaInCondition.getEnclosingStmt() = es
            and eva.getEnclosingStmt() = innerStmt
            and sink.asExpr() = eva
            and source.asExpr() = evaInCondition
            and DataFlow::localFlow(source, sink)
    ) 
}

predicate evaIsInEnumSingleStateBlock(EnumerationVariableAccess eva) {
    exists( Expr condition, 
            Stmt conditionStmt, 
            ConditionalStmt cs,
            ConditionalExpr ce,
            Loop l,
            EnumerationVariableAccess evaInCondition,
            DataFlow::Node source,
            DataFlow::Node sink| 
        
            conditionStmt = condition.getEnclosingStmt()
            and conditionStmt = evaInCondition.getEnclosingStmt()
            and eva != evaInCondition
            and (
                condition = ce.getCondition() or
                condition = l.getCondition() or
                (cs instanceof IfStmt and 
                    condition = cs.(IfStmt).getCondition()) or
                (cs instanceof SwitchStmt and
                    condition = cs.(SwitchStmt).getControllingExpr())
            )
            and not allowSingleState(evaInCondition.getEnclosingElement())

            // limit this only in the block single state 
            and sink.asExpr() = eva
            and source.asExpr() = evaInCondition
            and DataFlow::localFlow(source, sink)
    )
}


from EnumerationVariableAccess eva
where not evaIsInEnumSingleStateBlock(eva)
and not evaIsSingleStateInSwitchCase(eva)
and not exists(EnumConstantAccess ceva | 
               eva.getEnclosingElement() = ceva.getEnclosingElement())
select eva


// this select all condition that allow only single
// from Expr condition, 
// Stmt conditionStmt, 
// ConditionalStmt cs,
// ConditionalExpr ce,
// Loop l,
// EnumerationVariableAccess evaInCondition
// where conditionStmt = condition.getEnclosingStmt()
// and conditionStmt = evaInCondition.getEnclosingStmt()
// and (
//     condition = ce.getCondition() or
//     condition = l.getCondition() or
//     (cs instanceof IfStmt and 
//         condition = cs.(IfStmt).getCondition()) or
//     (cs instanceof SwitchStmt and
//         condition = cs.(SwitchStmt).getControllingExpr())
// )
// and not allowSingleState(evaInCondition.getEnclosingElement())

    
// select evaInCondition, evaInCondition.getEnclosingStmt() 


// from EnumSwitch es, 
//      SwitchCase sc, 
//      EnumerationVariableAccess evaInCondition,
//      EnumerationVariableAccess eva,
//      Stmt innerStmt, 
//      DataFlow::Node source,
//      DataFlow::Node sink

// // selecting all switch case in enumSwitch
// where es.getASwitchCase() = sc
// // that are not a default case
// and sc.toString() != "default: "
// // selecting all inner stmt of the case sc
// and innerStmt = sc.getAStmt*()
// // that are not the case statement
// and innerStmt != sc
// // selecting the eva present in the switch stmt
// and evaInCondition.getEnclosingStmt() = es
// // selecting all the eva present in the case switch
// and eva.getEnclosingStmt() = innerStmt
// // selecting the eva that flow from the eva in switch
// and sink.asExpr() = eva
// and source.asExpr() = evaInCondition
// and DataFlow::localFlow(source, sink)

// // so this query will find all the eva that are a single state
// // inside switch case

// select sc, evaInCondition, eva


