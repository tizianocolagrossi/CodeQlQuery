import cpp

class EnumerationVariable extends Variable{
    EnumerationVariable(){
        (exists(Enum e | this.getType() = e )
        or 
        exists(TypedefType tdt, Enum e | 
                    tdt.getBaseType() = e 
                    and 
                    this.getType() = tdt )
        )
    }
}

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


Loop getAnEnclosingLoopOfExpr(Expr e) { 
    result = getAnEnclosingLoopOfStmt(e.getEnclosingStmt()) 
}

Loop getAnEnclosingLoopOfStmt(Stmt s) {
    result = s.getParent*() and
    not s = result.(ForStmt).getInitialization()
    or
    result = getAnEnclosingLoopOfExpr(s.getParent*())
}

IfStmt getAnEnclosingIfStmtOfExpr(Expr e){
    result = getAnEnclosingIfStmtOfStmt(e.getEnclosingStmt()) 
}

IfStmt getAnEnclosingIfStmtOfStmt(Stmt s){
    result = s.getParent*() and 
    not s = result 
    or 
    result = getAnEnclosingIfStmtOfExpr(s.getParent*()) 
}

SwitchStmt getAnEnclosingSwitchStmtOfExpr(Expr e){
    result = getAnEnclosingSwitchStmtOfStmt(e.getEnclosingStmt()) 
}

SwitchStmt getAnEnclosingSwitchStmtOfStmt(Stmt s){
    result = s.getParent*() and
    not s = result
    or
    result = getAnEnclosingSwitchStmtOfExpr(s.getParent*())
}


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

int getNumberOfConstants(Enum e){
    result = max(
        int index, 
        EnumConstant ec
        | 
        ec =  e.getEnumConstant(index)
        |    
        index )
}

Enum getEnumType(EnumerationVariableAccess eva){
    result = eva.getType() and eva.getType() instanceof Enum
    or
    result = eva.getType().(TypedefType).getBaseType()
}