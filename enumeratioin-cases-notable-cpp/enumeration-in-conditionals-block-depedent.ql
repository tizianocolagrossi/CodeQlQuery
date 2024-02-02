/**
 * @description Condition that can be visited with multiple values of enumeration and inner block dependent on enumeration
 * @name conditional not single true block dependent
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/enum-condition-not-single-enum
 */

 import cpp
 import modules.EnumerationsModule
 import semmle.code.cpp.dataflow.new.DataFlow

//  from ConditionalStmt conds, 
//       EnumerationVariableAccess eva, 
//       BlockStmt bs, 
//       DataFlow::Node source, 
//       DataFlow::Node sink,
//       string conditionalThenOrElse
//  where 
//  eva.getEnclosingStmt() = conds
//  and
// //  (
// //     (
// //         eva.getEnclosingElement().toString() = "... && ..."
// //         or eva.getEnclosingElement().toString() = "... || ..."
// //         or eva.getEnclosingElement().toString() = "... != ..."
// //         or eva.getEnclosingElement().toString() = "... <= ..."
// //         or eva.getEnclosingElement().toString() = "... < ..."
// //         or eva.getEnclosingElement().toString() = "... >= ..." 
// //         or eva.getEnclosingElement().toString() = "... > ..." 
// //         or eva.getEnclosingElement().toString() = "if (...) ..."
// //     )
// //     and conds.getAChild().(BlockStmt) = bs
// //     and source.asExpr() = eva.(Expr)
// //     and sink.asExpr().getEnclosingBlock().getParentStmt*().(BlockStmt) = bs
// //     and DataFlow::localFlow(source, sink)
// //     and conditionalThenOrElse = "then"
// //  )
// //  or(
//     //      // [TODO] add if single state to check and follow if they have and else statement
//     conds instanceof IfStmt
//     and(
//         eva.getEnclosingElement().toString() = "... == ..."
//         or eva.getEnclosingElement().toString() = "! ..."
//     )
//     and conds.(IfStmt).hasElse()
//     and conds.(IfStmt).getElse().(BlockStmt) = bs // here only else
//     and source.asExpr() = eva.(Expr) 
//     and sink.asExpr().getEnclosingBlock().getParentStmt*().(BlockStmt) = bs
//     and not exists( IfStmt innerifs, DataFlow::Node innersource,DataFlow::Node innersink  | 
//         // sink.asExpr().getEnclosingBlock().getParentStmt*().(IfStmt) = innerifs
//         // and innerifs != conds
//     ) 
//     and DataFlow::localFlow(source, sink)
//     and conditionalThenOrElse = "else"

//     // [TODO] remove cases on which variable accessed is used in another if and 
//     //        is unique case

// //  )


//  select conds, "ConditionalStmt "+conditionalThenOrElse+" of variable '"+eva.toString()+"' can be visited with multiple values of $@ and the inner $@ of the conditional is dependent on the variable", 
//  eva.getType(), 
//  eva.getType().getName(),
//  bs, 
//  "block"

// class EnumMultiStateBlockStmt extends BlockStmt{
//     EnumMultiStateBlockStmt(){
//         exists(EnumerationVariableAccess eva, ConditionalStmt conditional | 
//             eva.getEnclosingStmt() = conditional
//             and(
//                 (
//                     (
//                         eva.getEnclosingElement().toString() = "... && ..."
//                         or eva.getEnclosingElement().toString() = "... || ..."
//                         or eva.getEnclosingElement().toString() = "... != ..."
//                         or eva.getEnclosingElement().toString() = "... <= ..."
//                         or eva.getEnclosingElement().toString() = "... < ..."
//                         or eva.getEnclosingElement().toString() = "... >= ..." 
//                         or eva.getEnclosingElement().toString() = "... > ..." 
//                         or eva.getEnclosingElement().toString() = "if (...) ..."
//                     )
//                     // maybe differentiate between switch if ternaryop
//                     // here i take only the first BlockStmt
//                     and this = conditional.getAChild().(BlockStmt)
//                 )
//                 or
//                 (
//                     conditional instanceof IfStmt
//                     and( 
//                         eva.getEnclosingElement().toString() = "... == ..."
//                         or eva.getEnclosingElement().toString() = "! ..."
//                     )
//                     and conditional.(IfStmt).hasElse()
//                     and this = conditional.(IfStmt).getElse()
//                 )
//             )         
//         )
//     }

    
// }

class EnumMultiStateConditional extends ConditionalStmt{
    EnumMultiStateConditional(){
        exists(EnumerationVariableAccess eva | 
            eva.getEnclosingStmt() = this
            and(
                eva.getEnclosingElement().toString() = "... && ..."
                or eva.getEnclosingElement().toString() = "... || ..."
                or eva.getEnclosingElement().toString() = "... != ..."
                or eva.getEnclosingElement().toString() = "... <= ..."
                or eva.getEnclosingElement().toString() = "... < ..."
                or eva.getEnclosingElement().toString() = "... >= ..." 
                or eva.getEnclosingElement().toString() = "... > ..." 
                or eva.getEnclosingElement().toString() = "if (...) ..."
            )or(
                this instanceof IfStmt
                and this.(IfStmt).hasElse()
                and( 
                    eva.getEnclosingElement().toString() = "... == ..."
                    or eva.getEnclosingElement().toString() = "! ..."
                )
            )  
        )

    }

    BlockStmt getMultiStateBlockStmt(){
        ((
            this.getEVA().getEnclosingElement().toString() = "... && ..."
            or this.getEVA().getEnclosingElement().toString() = "... || ..."
            or this.getEVA().getEnclosingElement().toString() = "... != ..."
            or this.getEVA().getEnclosingElement().toString() = "... <= ..."
            or this.getEVA().getEnclosingElement().toString() = "... < ..."
            or this.getEVA().getEnclosingElement().toString() = "... >= ..." 
            or this.getEVA().getEnclosingElement().toString() = "... > ..." 
            or this.getEVA().getEnclosingElement().toString() = "if (...) ..."
        )
        and result = this.getAChild().(BlockStmt))
        or((
                this.getEVA().getEnclosingElement().toString() = "... == ..."
                or this.getEVA().getEnclosingElement().toString() = "! ..."
            )
            and this instanceof IfStmt
            and this.(IfStmt).hasElse()
            and result = this.(IfStmt).getElse()
        )
        
    }

    EnumerationVariableAccess getEVA(){
        exists(EnumerationVariableAccess eva |
            eva.getEnclosingStmt() = this
            and result = eva
        )
    }
}

from EnumMultiStateConditional multiConditional, 
      DataFlow::Node source, 
      DataFlow::Node sink

where
source.asExpr() = multiConditional.getEVA()
and sink.asExpr() instanceof EnumerationVariableAccess
and sink.asExpr().getEnclosingStmt().getEnclosingBlock*() = multiConditional.getMultiStateBlockStmt()
and DataFlow::localFlow(source, sink)
and sink.asExpr().getEnclosingElement().toString() != "... == ..."
and sink.asExpr().getEnclosingElement().toString() != "! ..."
and source.asExpr().getEnclosingStmt() != sink.asExpr().getEnclosingStmt()
and not sink.asExpr().getEnclosingStmt() instanceof SwitchStmt
and not sink.asExpr().getEnclosingStmt() instanceof IfStmt

// select multiConditional, multiConditional.getEVA(), multiConditional.getMultiStateBlockStmt(), sink, "Ciaone"
select multiConditional, "ConditionalStmt of variable '"+multiConditional.getEVA().toString()+"' can be visited with multiple values of $@ and in the inner $@ of the conditional the variable $@ is dependent from the enumeration", 
multiConditional.getEVA().getType(), 
multiConditional.getEVA().getType().getName(),
multiConditional.getMultiStateBlockStmt(),
"block",
sink,
sink.toString()