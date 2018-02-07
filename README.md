= Nested Benchmark

== Author

Bruce Williams <bruce@codefluency.com>
http://codefluency.com

== Synopsis

The purpose of the nested-benchmark library is to add simple support for:
* Named, nested benchmarks that you don't have to keep track of to output later
* Blocks of code you want ignored by the benchmarks

== Usage

Requiring the library is intentionally similar to the Ruby Standard Library 'benchmark'

  require 'benchmark/nested'
  
Note that it's 'benchmark/nested' and NOT 'nested/benchmark'

This adds two methods to Object; +benchmark+ and +ignore+.  Here's an example of usage:

  benchmark "Insert 30 records" do
    ignore do 
      # Some database setup you don't want benchmarked
    end
    1.upto(30) do |number|
      benchmark "Prepare record ##{number} for insertion" do
        sleep rand(0.3)
        # something that takes some time
      end
      sleep rand(0.1)
      # insert into database
    end
  end
  
Afterwards, you can get the results by:

  puts Benchmark::CAPTION # Just for some headers
  NestedBenchmark.each do |benchmark|
    # Note these are the toplevel benchmarks
    puts benchmark
  end

and get something like:
  
  user       system     total      real
  0.010000   0.000000   0.010000 ( 25.789001) Insert 30 records
  0.000000   0.000000   0.000000 (  0.409687) > Prepare record #1 for insertion
  0.000000   0.000000   0.000000 (  0.332127) > Prepare record #2 for insertion
  0.000000   0.000000   0.000000 (  0.774727) > Prepare record #3 for insertion
  0.000000   0.000000   0.000000 (  0.522462) > Prepare record #4 for insertion
  0.000000   0.000000   0.000000 (  0.099711) > Prepare record #5 for insertion
  
You could also crawl the benchmarks manually if you want:

  NestedBenchmark.each do |benchmark|
    benchmark.each do |child|
      child.each do |grandchild|
        # ...
      end
    end
  end

== Caveats

Don't put a +benchmark+ inside an +ignore+.

It doesn't really make any sense, and neither will the results.

  