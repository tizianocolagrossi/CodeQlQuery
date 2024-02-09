
import cpp
import modules.EnumerationsModule


from EnumerationVariable ev, Enum e, int c
where (e = ev.getType() or ev.getType().(TypedefType).getBaseType() = e)
and c = count(
                EnumConstant ec 
                | 
                ec.getAnAccess().getEnclosingElement() = ev.getAnAccess().getEnclosingElement() 
                and
                ec.getAnAccess().getEnclosingElement() instanceof ComparisonOperation
                | 
                ec
            )

select ev, e, c, getNumberOfConstants(e)