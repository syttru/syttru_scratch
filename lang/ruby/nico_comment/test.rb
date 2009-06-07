require 'cgi'
require 'net/http'
require 'net/https'
require "rexml/document"

class NicoClient
  attr_accessor :session, :flv, :thread, :postkey

  def initialize
    @https = Net::HTTP.new('secure.nicovideo.jp',443)
    @https.use_ssl = true
    @https.ca_file = './nicovideo.pem'
    @https.verify_mode = OpenSSL::SSL::VERIFY_PEER
    @https.verify_depth = 5

    Net::HTTP.version_1_2

  end

  def login(mail, password)
    @https.start do |w|
      response = w.post('/secure/login?site=niconico',
        "mail=#{mail}&password=#{password}")
      return nil if(response.code.to_i != 302)
      pattern = /user_session=(user_session_\d+_\d+)/
      session_cookie = response.get_fields('set-cookie').find do |cookie|
        pattern.match(cookie)
      end
      @session = pattern.match(session_cookie)[1]
    end
  end

  def getflv(vid)
    Net::HTTP.start('www.nicovideo.jp', 80) do |http|
      response = http.get("/api/getflv/#{vid}",
          "Cookie" => "user_session=#{@session}")
      @flv = {}
      response.body.split(/&/).each do |elem|
        key, val = elem.split(/=/)
        @flv[key] = CGI.unescape(val)
      end
    end
  end

  def packet
    Net::HTTP.start('msg.nicovideo.jp', 80) do |http|
      path = @flv['ms'].gsub(/^http\:\/\/msg\.nicovideo\.jp/, '')
      response = http.post(path, self.packet_data,
          "Cookie" => "user_session=#{@session}")
      doc = REXML::Document.new response.body
      @thread = {}
      doc.elements['/packet/thread'].attributes.each do |k,v|
        @thread[k] = v
      end
    end
  end

  def packet_data
    "<packet>" +
      "<thread thread=\"#{@flv['thread_id']}\" " +
              "version=\"20061206\" " +
              "res_from=\"-1\" " +
              "user_id=\"#{@flv['user_id']}\"/>" +
    "</packet>"
  end
  
  def getpostkey
    block_no = @thread['last_res'].to_i / 100
    thread_id = @flv['thread_id']
    path = "/api/getpostkey/?yugi=&block_no=#{block_no}&thread=#{thread_id}"
    puts path
    Net::HTTP.start('www.nicovideo.jp', 80) do |http|
      response = http.get(path,
          "Cookie" => "user_session=#{@session}")
      response.body.split(/&/).each do |elem|
        key, val = elem.split(/=/)
        @postkey = CGI.unescape(val)
      end
    end
  end

  def comment(message, vpos)
    Net::HTTP.start('msg.nicovideo.jp', 80) do |http|
      path = @flv['ms'].gsub(/^http\:\/\/msg\.nicovideo\.jp/, '')
      response = http.post(path, self.comment_data(message, vpos),
          "Cookie" => "user_session=#{@session}")
      puts response.body
      doc = REXML::Document.new response.body
      result = {}
      doc.elements['/packet/chat_result'].attributes.each do |k,v|
        result[k] = v
      end
    end
  end

  def comment_data(message, vpos)
    "<chat thread=\"#{@flv['thread_id']}\" " +
          "vpos=\"#{vpos}\" " +
          "mail=\"184 \" " +
          "ticket=\"#{@thread['ticket']}\" " +
          "user_id=\"#{@flv['user_id']}\" " +
          "postkey=\"#{@postkey}\">" + 
      message +
    "</chat>"
  end
end

email = ARGV[0]
password = ARGV[1]
vid = ARGV[2]
message = ARGV[3]
vpos = ARGV[4]

client = NicoClient.new

if(client.login(email, password) == nil) then
  puts 'ログイン失敗'
  exit
end
puts client.session

client.getflv(vid)
client.flv.each do |k,v|
  puts "#{k}=#{v}"
end

client.packet
client.thread.each do |k,v|
  puts "#{k}=#{v}"
end

client.getpostkey
puts client.postkey

client.comment(message, vpos)
