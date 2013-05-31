#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require_relative 'hosting_base.rb'

class GitHub < HostingBase
  ROOT_URL = "https://api.github.com"
  OAUTH_ROOT_URL = "https://github.com/login"

  def init
    authentification(OAUTH_ROOT_URL)
  end
end
