require 'prime'
require 'benchmark'

Benchmark.bm(15) do |x|
  x.report('TrialDivision') do 
    10.times { Prime.each(1000000, generator = Prime::TrialDivisionGenerator.new).count}
  end
  x.report('Eratosthenes') do 
    10.times { Prime.each(1000000, generator = Prime::EratosthenesGenerator.new).count}
  end
end


