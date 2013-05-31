#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'json'

class GitpitConfig
  DEFAULT_CONFIG_PATH = ENV["HOME"] + "/.gitpit"

  def initialize
    @config = {}
  end

  def load(config_path = DEFAULT_CONFIG_PATH)
    if File.exists?(config_path)
      begin
        json = File.open(config_path).read
        @config = JSON.parse(json)
      rescue
        STDERR.puts "Failed to load #{config_path}"
        exit 1
      end
    end
  end

  def save(config_path = DEFAULT_CONFIG_PATH)
    begin
      json = JSON.generate(@config)
      File.open(config_path, "w") {|f| f.puts json }
    rescue
      STDERR.puts "Failed to save to #{config_path}"
      exit 1
    end
  end

  def get(service)
    @config[service] || {}
  end

  def set(service, params)
    @config[service] = params
  end
end
