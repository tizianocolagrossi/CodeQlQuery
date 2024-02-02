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