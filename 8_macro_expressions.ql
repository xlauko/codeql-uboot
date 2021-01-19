import cpp

from MacroInvocation m
where m.getMacro().getName().regexpMatch("ntoh(s|l|ll)")
select m.getExpr(), "ntoh macro invocation expr"
