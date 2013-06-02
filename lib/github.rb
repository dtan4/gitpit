#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require_relative 'hosting_base.rb'

class GitHub < HostingBase
  ROOT_URL = "https://api.github.com"
  OAUTH_ROOT_URL = "https://github.com/login"

  def init
    params = {}

    params[:scopes] = ["repo"]
    params[:note] = "gitpit"

    begin
      print "GitHub user name: "
      username = STDIN.gets.strip
      print "Password: "
      password = STDIN.gets.strip

      url = ROOT_URL.gsub(/:\/\//, "://#{username}:#{password}@") + "/authorizations"
      response = api_request(url, params, :post)

      if response["id"]
        puts response
        config = @config.get(self.class)
        config[:access_token] = response["token"]
        @config.set(self.class, config)
        @config.save

        puts "Success!"
      else
        raise Exception
      end
    rescue
      STDERR.puts "Authentification failed"
      retry
    end
  end

  def create(scope, repo_name)
    config = @config.get(self.class)
    params =
      {name: repo_name, private: scope == "private", access_token: config["access_token"]}
    url = ROOT_URL + "/user/repos"
    result = api_request(url, params, :post)

    if result
      repo_url_ssh = result["ssh_url"]
      puts "Remote repository was created on GitHub."
      puts result["html_url"]

      # add remote repository to .git/config
      system("git remote add origin #{repo_url_ssh}")
      puts "Remote repository origin was registrated."
    end
  end

  def list(scope)
    config = @config.get(self.class)
    params= {type: scope, access_token: config["access_token"]}
    url = ROOT_URL + "/user/repos"
    result = api_request(url, params, :get)

    result.each do |repo|
      puts repo["name"]
    end if result
  end
end
