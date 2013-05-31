#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'oauth'
require 'oauth/consumer'

require_relative './gitpit_config.rb'

class HostingBase
  def initialize
    @config = GitpitConfig.new
    @config.load
  end

  def authentification(site_url)
    begin
      print "   Consumer key: "
      consumer_key = STDIN.gets.strip

      print "Consumer secret: "
      consumer_secret = STDIN.gets.strip

      @consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {site: site_url})

      @request_token = @consumer.get_request_token
      @authorize_url = @request_token.authorize_url
    rescue
      puts @consumer.inspect
      STDERR.puts "Authentification failed"
      retry
    end

    puts ""
    puts "   *** Please access the URL below, and get PIN code. ***"
    puts ""
    puts @authorize_url
    puts ""

    begin
      print "PIN code: "
      pin_code = STDIN.gets.strip

      a_token = @request_token.get_access_token(oauth_verifier: pin_code)
      access_token = a_token.token
      access_secret = a_token.secret

      config = @config.get(self.class)
      config[:access_token] = access_token
      config[:access_secret] = access_secret

      @config.save
    rescue
      STDERR.puts "Authentification failed"
      retry
    end
  end

  def create

  end

  def list

  end
end
