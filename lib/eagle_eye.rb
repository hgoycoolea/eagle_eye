require "eagle_eye/version"

require 'nokogiri'
require 'mechanize'
require 'mysql2'
require 'waitutil'
require 'colorize'
require 'alexa_rubykit'
require "cgi"
require "base64"
require "openssl"
require "digest/sha1"
require "uri"
require "net/https"
require "rexml/document"
require "time"

module EagleEye
  SERVICE_HOST = "awis.amazonaws.com"
  # client global variable
  @@client = Mysql2::Client.new(:host => "localhost", :username => "develop", :database => 'crawler',:password=>'periquito123')
# ###############################
#
# crawl
#
# Method Crawler Engine
# @author :   Hector Goycoolea
#
# ###############################
def crawl
# exception management
    begin
      # puts starting
      puts "starting processing .... please wait .."

      puts "Usage: urlinfo.rb AKIAITB22UNBAT65NKZA bc1rLqAKgyshJ31Rk8IgydB1gc6PoZGk+4YXtO2H site"
      access_key_id ="AKIAITB22UNBAT65NKZA"
      secret_access_key = "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"
      site = "google.com.sa"

      action = "UrlInfo"
      responseGroup = "Rank,LinksInCount"
      timestamp = ( Time::now ).utc.strftime("%Y-%m-%dT%H:%M:%S.000Z")

      query = {
          "Action"           => action,
          "AWSAccessKeyId"   => access_key_id,
          "Timestamp"        => timestamp,
          "ResponseGroup"    => responseGroup,
          "SignatureVersion" => 2,
          "SignatureMethod"  => "HmacSHA1",
          "Url"              => site
      }


      query_str = query.sort.map{|k,v| k + "=" + escapeRFC3986(v.to_s())}.join('&')

      sign_str = "GET\n" + SERVICE_HOST + "\n/\n" + query_str

      puts "String to sign:\n#{sign_str}\n\n"

      signature = Base64.encode64( OpenSSL::HMAC.digest( OpenSSL::Digest::Digest.new( "sha1" ), secret_access_key, sign_str)).strip
      query_str += "&Signature=" + escapeRFC3986(signature)

      url = URI.parse("http://" + SERVICE_HOST + "/?" + query_str)

      puts "Making request to:\n#{url}\n\n"

      xml  = REXML::Document.new( Net::HTTP.get(url) )

      pp xml

      print "Response:\n\n"
      print "Links in count: "
      REXML::XPath.each(xml,"//aws:LinksInCount"){|el| puts el.text}
      print "Rank: "
      REXML::XPath.each(xml,"//aws:Rank"){|el| puts el.text}

=begin
      # agent mechanize
      agent = Mechanize.new
      # agent alias, this replaces the user_agent
      agent.user_agent_alias = 'Mac Safari'

      response = AlexaRubykit::Response.new
      response.add_speech('Ruby is running ready!')
      json_result = response.build_response

      pp json_result
=end

      # query to insert into the database
      #@@client.query("INSERT INTO `crawler`.`fb_json_friends` (`avatar_id`, `usuario`, `json_dump`) VALUES('"+ vanity + "','"+ username + "','" + page.body + "');", :async => true)
    end
  rescue Exception => e
# puts the exception
    puts e.message
# backtrace to inspect
#puts e.backtrace.inspect
# information to the error of the thread
#puts "error on thread"
  end

# escape str to RFC 3986
  def escapeRFC3986(str)
    return URI.escape(str,/[^A-Za-z0-9\-_.~]/)
  end

# for the parent module
extend self
end

