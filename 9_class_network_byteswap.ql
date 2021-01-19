import cpp

class NetworkByteSwap extends Expr {
  NetworkByteSwap () {
    exists( MacroInvocation m |
        m.getMacro().getName().regexpMatch("ntoh(s|l|ll)")
        and this = m.getExpr()
    )
  }
}

from NetworkByteSwap n
select n, "Network byte swap"
