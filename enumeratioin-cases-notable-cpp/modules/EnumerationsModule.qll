import cpp



class EnumerationVariableAccess extends VariableAccess{
    EnumerationVariableAccess(){
        (exists(Enum e | this.getType() = e )
        or 
        exists(TypedefType tdt, Enum e | 
                    tdt.getBaseType() = e 
                    and 
                    this.getType() = tdt ))
        and 
         // filtering call to functions
        not exists(FunctionCall fc, int i | fc.getArgument(i) = this)
        
    }

}

class EnumerationVariableAccessConstant extends EnumerationVariableAccess{
    EnumerationVariableAccessConstant(){
        exists(EnumConstantAccess eca | 
            this.getEnclosingElement() = eca.getEnclosingElement())
    }
}

class EnumIfStmtMultistate  extends IfStmt{
    EnumIfStmtMultistate(){
        exists(EnumerationVariableAccess eva | 
            eva.getEnclosingStmt() = this
        )
    }

    predicate isSingleConditional(){
        not this.getCondition() instanceof BinaryLogicalOperation
    }

    predicate allowMultistate(Element x){
        x.toString() = "... && ..." or
        x.toString() = "... || ..." or
        x.toString() = "... != ..." or
        x.toString() = "... <= ..." or
        x.toString() = "... < ..."  or
        x.toString() = "... >= ..." or
        x.toString() = "... > ..."  or
        x.toString() = "... + ..."  or
        x.toString() = "... - ..."  or
        x.toString() = "... << ..."  or
        x.toString() = "... >> ..."  or
        x.toString() = "& ..."  or
        x.toString() = "access to array" or
        x.toString() = "call to expression" or
        x.toString() = "if (...) ... "
    }
    //schifo sistema qui
    predicate hasEnumMultistateThen(){
        allowMultistate(this.getEVACondition()) or
        (
            this.getEVACondition().toString() = "... & ..." and
            allowMultistate(this.getEVACondition().getEnclosingElement())
        )
    }

    predicate hasEnumMultistateElse(){
        this.hasElse()
        and not this.hasEnumMultistateThen()
    }

    EnumerationVariableAccess getEVA(){
        exists(EnumerationVariableAccess eva |
            eva.getEnclosingStmt() = this
            and result = eva
        )
    }

    Element getEVACondition(){
        result = this.getEVA().getEnclosingElement()
    }

    BlockStmt getMultiStateBlockStmt(){
        (
            this.hasEnumMultistateThen() and
            result = this.getThen()
        )or(
            this.hasEnumMultistateElse() and 
            result = this.getElse()
        )
    }

}