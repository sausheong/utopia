require 'gruff'
require 'csv'
require 'fileutils'
require 'histogram'
require 'histogram/array'
require 'prawn'
require 'prawn/layout'

def gini_coefficient(array)
  data = [0] + array.sort  
  cumulative = data.map.with_index do |item, i|
    (0.5 * (data[i] + data[i+1])) if i < data.size-1
  end.compact  
  b = cumulative.inject(:+)
  a = (0.5 * array.size * array.max) - b
  a/(a+b)
end

data = CSV.read "./results/data/money.csv"

points = [0,25,50,100,500,1000,1500,1999]

points.each do |row|
  tdata = data[row].map {|i| i.to_i}.sort
  percentages = (0..100).step(10).to_a

  cumulative = percentages.collect do |percent|
    tdata.take(tdata.size * percent/100.0).inject(:+) || 0
  end

  total_equality = percentages.collect do |percent|
    (tdata.inject(:+) * percent/100.0).to_i
  end

  chart = Gruff::Line.new(220)
  chart.theme_pastel
  chart.title = "Inequality at t=#{row} (#{'%0.2f' % gini_coefficient(tdata)})"
  labels = {}
  percentages.size.times {|i| labels[i] = percentages[i].to_s}
  chart.labels = labels
  chart.hide_legend = true
  chart.maximum_value = cumulative.max
  chart.minimum_value = 0
  chart.data percentages, cumulative
  chart.data percentages, total_equality
  chart.write "./results/reports/ineq_#{row}.png"
end

Prawn::Document.generate('./results/reports/inequality.pdf') do |pdf|
  pdf.define_grid columns: 2, rows: 4, gutter: 5  
  groupings = points.group_by{|i| points.index(i)%4}.values.to_a  
  groupings.transpose.each_with_index do |group, i|
    group.each_with_index do |item, j|
      pdf.grid(j, i).bounding_box do
        pdf.image "./results/reports/ineq_#{item}.png"
      end      
    end
  end
end

FileUtils.rm Dir.glob './results/reports/*.png'