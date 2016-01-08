#!/usr/bin/env ruby

require 'json'
require 'date'
require 'tempfile'

def week_start( date, offset_from_sunday=1 )
    date - (date.wday - offset_from_sunday)%7
end

jsfile = File.read('enron_internal_sent.json')
days = Hash.new { |h, k| h[k] = 0 }
enronjson = JSON.parse(jsfile)


enronjson.each do |message| 
  date = DateTime.parse(message['timestamp']).to_date
  days[week_start(date)] += 1
end

Tempfile.open('data') do |datafile|
  datafile.puts("date,count")
  days.sort_by{ |date, count| date }.each do |date, count|
    datafile.puts "#{date},#{count}"
  end
  datafile.flush
  system(%Q^gnuplot -e "inputfile='#{datafile.path}'" plot.gpl -persist^)
end
