require 'gruff'
require 'csv'
require 'fileutils'
require 'histogram'
require 'histogram/array'
require 'prawn'
require 'prawn/layout'

data = CSV.read "./results/data/money.csv"

points = [0,25,50,100,500,1000,1500,1999]

points.each do |row|
  tdata = data[row].collect{|e| e.to_i}
  bin = (0..tdata.max).step(tdata.max/20).to_a
  bins, freqs = tdata.histogram bin
  chart = Gruff::Bar.new(220)
  chart.theme_pastel
  chart.title = "Energy at t=#{row}"
  labels = {}
  bin.size.times {|i| labels[i] = bin[i].to_s if i % 4 == 0}
  chart.labels = labels
  chart.hide_legend = true
  chart.maximum_value = freqs.max.to_i
  chart.minimum_value = 0
  chart.data bin, freqs
  chart.write "./results/reports/money_#{row}.png"
end


Prawn::Document.generate('./results/reports/money.pdf') do |pdf|
  pdf.define_grid columns: 2, rows: 4, gutter: 5  
  groupings = points.group_by{|i| points.index(i)%4}.values.to_a  
  groupings.transpose.each_with_index do |group, i|
    group.each_with_index do |item, j|
      pdf.grid(j, i).bounding_box do
        pdf.image "./results/reports/money_#{item}.png"
      end      
    end
  end
end

FileUtils.rm Dir.glob './results/reports/*.png'