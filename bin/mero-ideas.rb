#!/usr/bin/env ruby

require_relative "../lib/mero_ideas"

begin
  MeroIdeas::CLI.new.run(ARGV)
rescue MeroIdeas::Error => e
  puts "Ошибка: #{e.message}"
  exit 1
rescue Interrupt
  puts "\nПрервано пользователем"
  exit 0
end