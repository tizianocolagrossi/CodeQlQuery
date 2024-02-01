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

