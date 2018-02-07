require 'benchmark'

module Benchmark
  
  class Tms
    
    include Enumerable
    
    attr_accessor :label
    attr_writer :children
    def children
      @children ||= []
    end
    
    def each(&block)
      children.each(&block)
    end
    
    def to_s(indent=0)
      lines = []
      lines << format(FMTSTR).rstrip
      indenter = ('>' * indent) + ' ' if indent > 0
      lines.last << " #{indenter}#{@label}"
      children.each do |child|
        lines << child.to_s(indent + 1)
      end
      lines.join("\n")
    end
    
  end
  
end