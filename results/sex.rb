require 'gruff'
require 'csv'

data = CSV.read "./results/data/sex.csv"
data = data.transpose
male, female, child = data[0], data[1], data[2]

chart = Gruff::Line.new(2048)
chart.theme_pastel
chart.data "Male", male.map{|item| item.to_i}, "#0000FF" # blue
chart.data "Female", female.map{|item| item.to_i}, "#FFFF00" # yellow
# chart.data "Child", child.map{|item| item.to_i}, "#E9967A" # darksalmon
chart.data "All", child.map{|item| item.to_i}, "#000000" # black
chart.write "./results/reports/sex.png"