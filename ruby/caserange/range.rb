#!/usr/bin/env ruby

require 'optparse'

Options = Struct.new(:node)
Specification = Struct.new(:processor, :cores, :memory)

class Parser
  def self.parse(args)
    options = Options.new
    OptionParser.new do |opts|
      opts.banner = "Usage: nodesummary [options]"
      opts.on('-n', '--node [NODENAME]', 'Node Name') do |n|
        options.node = n
      end
      opts.on('-h', '--help', 'Show this message') do
        puts opts
        exit
      end
    end.parse(args.empty? ? %w[--help] : args)
    raise OptionParser::MissingArgument if options.values.include?(nil)
    options
  end
end

def taurus(number)
  case number
  when 4001..4104
    Specification.new("haswell", 24, 62000)
  when 4105..4188
    Specification.new("haswell", 24, 126000)
  when 4189..4232
    Specification.new("haswell", 24, 254000)
  when 5001..5612
    Specification.new("haswell", 24, 62000)
  when 6001..6612
    Specification.new("haswell", 24, 62000)
  when 1001..1228
    Specification.new("sandy", 16, 30000)
  when 1229..1256
    Specification.new("sandy", 16, 62000)
  when 1257..1270
    Specification.new("sandy", 16, 126000)
  else
    Specification.new("Unknown", nil, nil)
  end
end

options = Parser.parse(ARGV)
if options.node =~ /taurusi([\d]+)/
  spec = taurus($1.to_i)
  if spec.processor != "Unknown"
    puts "#{options.node}: #{spec.cores} core #{spec.processor} processor, #{spec.memory}MB RAM\n"
  else 
    puts "UNKNOWN NODE" 
  end
else
  puts "UNKNOWN NODE"
end
