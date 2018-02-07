require File.dirname(__FILE__) << "/nested/benchmark"

class Object
  include NestedBenchmark
end