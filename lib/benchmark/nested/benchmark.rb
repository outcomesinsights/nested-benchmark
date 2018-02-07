require File.dirname(__FILE__) << '/tms_ext'

module NestedBenchmark
  
  class << self
    
    include Enumerable
    
    def each(&block)
      benchmarks.each(&block)
    end
    
    def benchmarks
      @benchmarks ||= []
    end
    
    def children_stack
      @children_stack ||= []
    end
    
    def ignores
      @ignores ||= []
    end
    
    def included(base)
      base.__send__(:include, InstanceMethods)
    end
    
    def ignore_in_parent(offset)
      NestedBenchmark.ignores.last << offset unless NestedBenchmark.ignores.empty?
    end
    
    def ignore
      offset = sum(NestedBenchmark.ignores.pop)
      ignore_in_parent offset
      offset
    end
    
    def calculate(&block)
      NestedBenchmark.ignores << []
      yield - ignore
    end
    
    def reset!
      benchmarks.clear
    end
    
    def sum(benchmarks)
      benchmarks.inject(Benchmark::Tms.new) do |result, benchmark|
        result + benchmark
      end
    end
    
    def add(benchmark)
      if NestedBenchmark.children_stack.empty?
        NestedBenchmark.benchmarks << benchmark
      else
        NestedBenchmark.children_stack.last << benchmark
      end
      benchmark
    end
    
  end
  
  module InstanceMethods
    
    def benchmark(name=nil, &block)
      NestedBenchmark.children_stack << []
      result = NestedBenchmark.calculate { Benchmark.measure(&block) }
      result.label = name
      result.children = NestedBenchmark.children_stack.pop
      NestedBenchmark.add result
    end
    
    def ignore(&block)
      NestedBenchmark.ignores.last << Benchmark.measure(&block)
    end
    
  end
  
end