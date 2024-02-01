import cpp



class EnumerationVariableAccess extends VariableAccess{
    EnumerationVariableAccess(){
        exists(Enum e | this.getType() = e )
        or 
        exists(TypedefType tdt, Enum e | 
                    tdt.getBaseType() = e 
                    and 
                    this.getType() = tdt )
        
    }
}

