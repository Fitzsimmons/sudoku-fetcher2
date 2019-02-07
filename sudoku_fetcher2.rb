require "nokogiri"
require "rest-client"

def sudoku_fetcher2(event:, context:)
  raw_data = get
  cheat, editmask = parse(raw_data)

  {
    isBase64Encoded: false,
    statusCode: 200,
    headers: { "Content-type" => "text/plain" },
    body: "#{cheat}\n#{editmask}"
  }

end

def get(difficulty=4)
  RestClient.get("http://view.websudoku.com/?level=#{difficulty}")
end

def parse(raw_data)
  dom = Nokogiri::HTML.parse(raw_data)
  cheat = dom.xpath('//input[@id="cheat"]').first["value"]
  editmask = dom.xpath('//input[@id="editmask"]').first["value"]

  return [cheat, editmask]
end
