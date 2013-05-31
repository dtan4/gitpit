#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require_relative 'lib/gitpit.rb'


if ARGV.length < 2
  # something
  exit 1
end

service, command, scope = ARGV[0..2]

repository = ARGV.length > 3 ? ARGV[3] : Dir.pwd.gsub(/(?:^\/|[^\/]+\/)/, '')

gitpit = Gitpit.new
gitpit.execute(service, command, scope, repository)
