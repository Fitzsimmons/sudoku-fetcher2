require "nokogiri"
require "rest-client"

DEFAULT_LEVEL = "4".freeze

def sudoku_fetcher2(event:, context:)
  level = event["queryStringParameters"] || DEFAULT_LEVEL

  raw_data = get(level)
  cheat, editmask = parse(raw_data)

  {
    isBase64Encoded: false,
    statusCode: 200,
    headers: { "Content-type" => "text/plain" },
    body: "#{cheat}\n#{editmask}"
  }
end

def get(level)
  RestClient.get("http://view.websudoku.com/?level=#{level}")
end

def parse(raw_data)
  dom = Nokogiri::HTML.parse(raw_data)
  cheat = dom.xpath('//input[@id="cheat"]').first["value"]
  editmask = dom.xpath('//input[@id="editmask"]').first["value"]

  return [cheat, editmask]
end
