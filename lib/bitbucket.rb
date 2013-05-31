#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require_relative './hosting_base.rb'

class Bitbucket < HostingBase
  ROOT_URL = "https://bitbucket.org/api/1.0"

  def init
    authentification(ROOT_URL)
  end
end
