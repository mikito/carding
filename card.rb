require 'open-uri'
require 'nokogiri'
require 'erb'
require 'fileutils'

url = 'https://cookpad.com/recipe/2069863'
charset = nil
html = open(url) do |f|
  charset = f.charset
  f.read
end

doc = Nokogiri::HTML.parse(html, nil, charset)

model = {}

model["title"] = doc.title.gsub("【クックパッド】 簡単おいしいみんなのレシピが279万品", "")


model["image"] = doc.xpath('//div[@id="main-photo"]/img').attribute('src').value

model["ingredients"] = []

doc.xpath('//div[contains(@class,"ingredient_row")]').each do |node|
  ingredient = {} 
  ingredient["name"] = node.xpath('div[@class="ingredient_name"]').inner_text.strip
  ingredient["quantity"] = node.xpath('div[@class="ingredient_quantity amount"]').inner_text.strip
  model["ingredients"] << ingredient
end

#doc.xpath('//dd[@class="instruction"]').each do |node|
#  p node.inner_text
#end

p model

template = File.read("card.erb")

File.open("card.html", mode = "w:utf-8") do |f|
  f.write(ERB.new(template, nil, '-').result(binding))
end
