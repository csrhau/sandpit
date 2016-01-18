#!/usr/bin/env ruby

require 'optparse'
require 'json'
require 'date'
require 'tempfile'

Options = Struct.new(:datafile,  :outfile)
class Parser
  def self.parse(args)
    options = Options.new
    opt_parser = OptionParser.new do |opts|
      opts.banner = 'Usage: ruby ruler.rb [args]'
      opts.on('-dFILE', '--data=FILE', 'Data Filename') { |f|  options.datafile = f }
      opts.on('-oFILE', '--output=FILE', 'Output Filename') { |f| options.outfile = f }
      opts.on('-h', '--help', 'Prints this help') do
        puts opts
      exit
    end
  end
  opt_parser.parse!(args)
  raise OptionParser::MissingArgument if options.datafile.nil?
  raise OptionParser::MissingArgument if options.outfile.nil?
  return options
  end
end

def week_start( date, offset_from_sunday=1)
    date - (date.wday - offset_from_sunday)%7
end

def process(args)
  options = Parser.parse args.empty? ? %w[--help] : args
  jsfile = File.read(options.datafile)
  weeks = Hash.new { |h, k| h[k] = 0 }
  cutoff = DateTime.parse('1990-01-01T00:00:00-00:00')
  JSON.parse(jsfile).each do |message| 
    date = DateTime.parse(message['timestamp']).to_date
    weeks[week_start(date)] += 1 if date > cutoff
  end

  File.open(options.outfile, 'w') do |outfile|
    outfile.puts"date,rate"
    weeks.sort_by{ |date, count| date }.each do |date, count|
      outfile.puts "#{date},#{count}"
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  process ARGV
end
