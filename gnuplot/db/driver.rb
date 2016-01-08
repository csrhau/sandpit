#!/usr/bin/env ruby

require 'csv'
require 'set'
require 'tempfile'

taints = Hash.new { |h, k| h[k] = SortedSet.new }
tmpfile = Hash.new { |h, k| h[k] = Tempfile.new('tmpplotdata') }
buys = Hash.new { |h, k| h[k] = Hash.new { |h,k| h[k] = 0 } } # stock:trader:count
sells = Hash.new { |h, k| h[k] = Hash.new { |h,k| h[k] = 0 } } # stock:trader:count
traders = SortedSet.new
symbols = SortedSet.new

rows = 0
CSV.foreach('data/trades-2015-03-08.csv.augmented', headers:true) do |row|
  symbol = row['symbol']
  seller = row['seller']
  buyer = row['buyer']
  state = row['state']
  traders.add(buyer)
  traders.add(seller)
  symbols.add(symbol)
  buys[symbol][buyer] += 1
  sells[symbol][seller] += 1
  if state != 'Benign'
    taints[symbol].add(state)
  end
  tmpfile[symbol].write(row)
  rows = rows + 1
  if rows % 25000 == 0
    puts rows
  end
end
puts rows

tmpfile.each do |symbol, file|
  puts "taints for #{symbol}: #{taints[symbol].to_a.join(' ')}"
  system(%Q^gnuplot -e "inputfile='#{file.path}'; outputfile='output/#{symbol}.png'" price.gpl^)
end
puts "here we are "

Tempfile.open('tmpbuyheatdata') do | heatfile |
  puts "here we go"
  heatfile.puts( "NULL,#{traders.to_a.join(',')}")
  symbols.each do |symbol| 
    heatfile.puts("#{symbol},#{buys[symbol].values.join(',')}")
    puts "#{symbol},#{buys[symbol].values.join(',')}"
  end
  system(%Q^gnuplot -e "inputfile='#{heatfile.path}'" heatmap.gpl -persist^)
  system(%Q^cp #{heatfile.path} ./example^)
end



