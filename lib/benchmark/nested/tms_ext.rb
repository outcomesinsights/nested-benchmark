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

    def to_s(opts = {})
      opts = { indent: 0 }.merge(opts)
      lines = []
      lines << format(FORMAT).rstrip

      indent = opts[:indent]
      indenter = ('>' * indent) + ' ' if indent > 0
      lines.last << " #{indenter}#{@label}"

      children.each do |child|
        lines << child.to_s(opts.merge(indent: indent + 1))
      end

      if opts[:include_remainder] && !children.empty?
        remainder_tms = (self - children.inject(:+))
        remainder_tms = "Remainder"
        lines << remainder_tms.to_s(indent: indent)
      end

      lines.join("\n")
    end
  end
end
