require 'gruff'
require 'csv'

data = CSV.read "./results/data/evolution.csv"
data = data.transpose
metabolism, vision_range = data[0], data[1]

chart = Gruff::Line.new(2048)
chart.theme_pastel
chart.data "Metabolism", metabolism.map{|item| item.to_i}, "#0000FF" # blue
chart.write "./results/reports/metabolism.png"

chart = Gruff::Line.new(2048)
chart.theme_pastel
chart.data "Vision Range", vision_range.map{|item| item.to_i}, "#FF0000" # blue
chart.write "./results/reports/vision_range.png"