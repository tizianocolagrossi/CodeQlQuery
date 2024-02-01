/**
 * This is an automatically generated file
 * @name Enumeration use
 * @id cpp/enumeration/use
 */

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


 from EnumerationVariableAccess eva 
 select eva, eva.getType()