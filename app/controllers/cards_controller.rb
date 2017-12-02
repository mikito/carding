class CardsController < ApplicationController
  def new
  end

  def create 
    #url = 'https://cookpad.com/recipe/2069863'
    url = params["url"]
    charset = nil

    html = open(url) do |f|
      charset = f.charset
      f.read
    end

    doc = Nokogiri::HTML.parse(html, nil, charset)

    @model = {}
    @model["title"] = doc.title.gsub("【クックパッド】 簡単おいしいみんなのレシピが279万品", "")
    @model["image"] = doc.xpath('//div[@id="main-photo"]/img').attribute('src').value
    @model["ingredients"] = []

    doc.xpath('//div[contains(@class,"ingredient_row")]').each do |node|
      ingredient = {} 
      ingredient["name"] = node.xpath('div[@class="ingredient_name"]').inner_text.strip
      ingredient["quantity"] = node.xpath('div[@class="ingredient_quantity amount"]').inner_text.strip
      @model["ingredients"] << ingredient
    end

    #doc.xpath('//dd[@class="instruction"]').each do |node|
    #  p node.inner_text
    #end
    #
    render :cards 
  end
end
