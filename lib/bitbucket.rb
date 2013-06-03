#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require_relative './hosting_base.rb'

class Bitbucket < HostingBase
  ROOT_URL = "https://bitbucket.org/api/1.0"

  def init
    authentification(ROOT_URL, {authorize_path: 'oauth/authenticate'})
  end

  def create(scope, repo_name)
    config = @config.get(self.class)
    params =
      {name: repo_name, is_private: scope == "private", access_token: config["access_token"]}
    url = ROOT_URL + "/repositories"
    result = api_request(url, params, :post)

    if result
      # git clone git@bitbucket.org:dtan4/snipstock.git
      owner = result['owner']
      repo_url_ssh = "git@bitbucket.org:#{owner}/#{repo_name}.git"
      html_url = "https://bitbucket.org/#{owner}/#{repo_name}"
      puts "Remote repository was created on Bitbucket."
      puts html_url

      # add remote repository to .git/config
      system("git remote add origin #{repo_url_ssh}")
      puts "Remote repository origin was registrated."
    end
  end

  def list(scope)
    config = @config.get(self.class)
    params= {oauth_access_token: config["access_token"], oauth_access_secret: config["access_secret"]}
    params = {}
    url = ROOT_URL + "/user/repositories"
    result = api_request(url, params, :get)

    result.each do |repo|
      puts repo["name"]
    end if result
  end
end
