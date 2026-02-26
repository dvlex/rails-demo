# print the odd square numbers
# nums = (1..10)
# evens_squared = nums.select(&:odd?).map { _1 * _1 }
# p evens_squared


# Lazy numbers, generates "N" amount of numbers, from 1 to infinite, here, we´re selecting first 15
# stream = (1..).lazy
# p stream.select(&:odd?).map { _1 * 3 }.first(15)


# delegates "yield"
# def with_log
#   puts "start"
#   result = yield(10)     # yield ejecuta el bloque
#   p result
#   puts "end"
# end
# with_log { |x| x * 2 } # => 20
# with_log do |x|
#   x * 2
# end


# Lambdas
# l = ->(x) { x * 2 }
# p l.call(3)  # 6
# # ---
# p1 = Proc.new { |x| x * 3 }  # aridad flexible
# p p1.call(2)               # nil
# # ---
# p2 = Proc.new do |x|
#   x * 3
# end
# p p2.call(1)
# ---
# def make_multiplier(n)
#   ->(x) { x * n }
# end
# times3 = make_multiplier(4)
# p times3.call(11)


# Extension methods
# module StringExtras
#   refine String do
#     def shout = upcase + "!"
#     def capitalize_words
#       split.map(&:capitalize).join(" ")
#     end
#   end
# end
# using StringExtras
# p "hola".shout
# p "hOla munDo".capitalize_words


# parallelism
# t1 = Thread.new { 3.times { puts "A"; sleep 0.1 } }
# t2 = Thread.new { 3.times { puts "B"; sleep 0.3 } }
# [ t1, t2 ].each(&:join)


# benchmarking
# require "benchmark"
# puts Benchmark.measure {
#   10_000_000.times { "a" + "b" }
# }


# sinatra (like rails but lightweight)
# require "sinatra"
# set :port, 3000
# get "/" do
#   "Hola desde Sinatra"
# end
# get "/saludo/:nombre" do
#   "Hola #{params[:nombre]}"
# end
