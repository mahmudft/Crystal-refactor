require "benchmark"

BRACKETS = {
  "percent" => [0.10, 0.12, 0.22, 0.24, 0.32, 0.35, 0.37],
  "single"  => [0, 9875, 40125, 85525, 163300, 207350, 518400],
  "married" => [0, 19750, 80250, 171050, 326600, 414700, 622050],
  "hoh"     => [0, 14100, 53700, 85500, 163300, 207350, 518400],
}

def calc_taxes(income, status = "single")
  bracket = BRACKETS[status]
  percentages = BRACKETS["percent"]
  index = bracket.index { |high| income < high } || bracket.size

  total_taxes = 0

  bracket.first(index).zip(percentages.first(index)).reverse.each do |lower, percent|
    diff_to_lower = (income - lower)
    total_taxes += diff_to_lower * percent
    income -= diff_to_lower
  end
  total_taxes
end

def calc_taxes_v2(income, status = "single")
  bracket = BRACKETS[status]
  percentages = BRACKETS["percent"]
  index = bracket.index { |high| income < high } || bracket.size
  total_taxes = 0
  (index - 1).downto(0).each do |num|
    # puts bracket[num]
    diff_to_lower = (income - bracket[num])
    total_taxes += diff_to_lower * percentages[num]
    income -= diff_to_lower
  end
  total_taxes
end

# puts calc_taxes_v2(100_000)
# puts calc_taxes(100_000)

Benchmark.ips do |x|
  x.report("original") do
    calc_taxes(50_000)
  end

  x.report("optimized") do
    calc_taxes_v2(50_000)
  end
end
