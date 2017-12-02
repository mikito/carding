class CardsController < ApplicationController
  def new
  end

  def index
    url = params["url"]
    return redirect_to :root if url.blank?

    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Get.new(uri.path)

    res = http.request(req)

    doc = Nokogiri::HTML.parse(res.body)

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

    @model["steps"] = []

    index = 0
    doc.xpath('//p[@class="step_text"]').each do |node|
      break if params["max_step"].present? && index >= params["max_step"].to_i
      @model["steps"] << node.inner_text.strip
      index += 1
    end

    @model["source"] = "Cookpad"
    @model["url"] = url

    render :layout => false 
  end
end
