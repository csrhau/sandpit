#!/usr/bin/env ruby

require 'json'
require 'tempfile'
require 'set'

msgs = Hash.new { |h, k| h[k] = Hash.new { |h,k| h[k] = 0 } } # stock:trader:count
senders = SortedSet.new

jsfile = File.read('inner_graph.json')
enronjson = JSON.parse(jsfile)


enronjson.each do |message| 
  from = message['sender']
  senders.add(from)
  message['recipients'].each do |to|
    msgs[from][to] += 1
  end
end
senders = senders.to_a

Tempfile.open('data') do |datafile|
  datafile.puts("NULL,#{senders.join(',')}")
  senders.each do |person|
    datafile.puts("#{person},#{senders.map{ |p| msgs[person][p] }.join(',')}")
  end
  datafile.flush
  system(%Q^gnuplot -e "inputfile='#{datafile.path}'" heatmap.gpl -persist^)
  `cp #{datafile.path} foo.data`
end
