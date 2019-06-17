require 'json'
require 'open-uri'

index = JSON.parse(File.read(ARGV[0]))
xref = JSON.parse(File.read(ARGV[1]))

Dir.mkdir('oggs') unless File.exists?('oggs')

array = index.map do |word|
  begin
    word_object = JSON.parse(`curl -s https://www.moedict.tw/t/#{word}.json`)
    ogg_id = word_object['h'][0]['_']
    download_ogg = open("https://1763c5ee9859e0316ed6-db85b55a6a3fbe33f09b9245992383bd.ssl.cf1.rackcdn.com/%05d.ogg" % ogg_id)
    IO.copy_stream(download_ogg, "oggs/%05d.ogg" % ogg_id)

    h = Hash.new
    h["ogg"] = "oggs/%05d.ogg" % ogg_id
    h["t"] = word

    if xref["a"][word].nil?
      h["c"] = []
    elsif xref["a"][word].empty?
      h["c"] = [word]
    else
      h["c"] = xref["a"][word].split(",")
    end

    h
  rescue StandardError => e
    nil
  end
end.reject.to_a

File.open("#{ARGV[2]}.json","w") do |f|
  f.write(array.to_json)
end
