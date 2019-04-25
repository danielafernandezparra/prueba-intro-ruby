require 'uri'
require 'net/http'
require 'openssl'
require 'json'


def request(address, api_key = "YLROto5j0y5Z0GlzL3zaFpyguI7IdJapjnQDLgpZ" )
  url = URI("#{address}&api_key=#{api_key}")
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)
  request["cache-control"] = 'no-cache'
  request["Postman-Token"] = 'a6a713da-b727-42e3-8e6c-44b2236faf7e'

  response = http.request(request)
  JSON.parse response.read_body
end

body = request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10")
# puts body

def buid_web_page(data)
  photos = data["photos"].map{|x| x['img_src']}
  html = "<html>\n<head>\n</head>\n<body>\n<ul>\n"
  photos.each do |photo|
    html += "<li><img src=\"#{photo}\"></li>\n"
  end
  html += "</ul>\n</body>\n</html>"
  File.write('output.html', html)
end

buid_web_page(body)

def photos_count(body)
  body['photos'].map{|x| x['camera']['name']}.group_by{|x| x}.map{|k,v| [k,v.count]}
end

puts photos_count(body)
