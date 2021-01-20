import cpp
import semmle.code.cpp.dataflow.TaintTracking
import DataFlow::PathGraph

class NetworkByteSwap extends Expr {
  NetworkByteSwap () {
    exists( MacroInvocation m |
        m.getMacro().getName().regexpMatch("ntoh(s|l|ll)")
        and this = m.getExpr()
    )
  }
}

class MemcpyCall extends FunctionCall {
    MemcpyCall () {
        exists( FunctionCall call |
            call.getTarget().getName() = "memcpy" and this = call )
    }
}

class Config extends TaintTracking::Configuration {
  Config() { this = "NetworkToMemFuncLength" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof NetworkByteSwap
  }
  override predicate isSink(DataFlow::Node sink) {
    exists( MemcpyCall memcpy | sink.asExpr() = memcpy.getArgument(2))
  }
}

from Config cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "Network byte swap flows to memcpy"
