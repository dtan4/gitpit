#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require_relative './github.rb'
require_relative './gist.rb'
require_relative './bitbucket.rb'

class Gitpit
  def execute(service, command, scope, repository)
    case service
    when 'github'
      @hosting = GitHub.new
    when 'gist'
      @hosting = Gist.new
    when 'bitbucket'
      @hosting = Bitbucket.new
    else
      # something
      exit 1
    end

    case command
    when 'init'
      @hosting.init
    when 'create'
      @hosting.create_repository(scope, repository)
    when 'list'
      @hosting.list_repositories(scope)
    else
      #something
      exit 1
    end
  end
end
