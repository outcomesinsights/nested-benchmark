require 'rubygems'
require 'test/spec'

require File.dirname(__FILE__) << "/test_helper"

context "Nested Benchmark" do
  
  specify "can use in arbitrary objects" do
    assert_supports_benchmarking_in Object.new
    assert_supports_benchmarking_in self
    assert_supports_benchmarking_in Class.new
    assert_supports_benchmarking_in Class.new.new
  end
  
  specify "benchmark returns a benchmark with children" do
    b = benchmark { benchmark { } }
    assert_kind_of Benchmark::Tms, b
    assert_kind_of Array, b.children
    assert_respond_to b, :each
    b.each do |c|
      assert_kind_of Benchmark::Tms, c
    end
  end
  
  specify "can reset toplevel benchmarks" do
    benchmark { benchmark { } }
    assert 1, benchmarks.size
    NestedBenchmark.reset!
    assert 0, benchmarks.size
  end
  
  #######
  private
  #######
  
  def benchmarks
    NestedBenchmark.benchmarks
  end

  def assert_supports_benchmarking_in(object)
    %w(benchmark ignore).all? { |m| object.respond_to?(m) }
  end
  
end