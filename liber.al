#!/usr/bin/ruby

require 'ftools'
require 'logger'

DIR = ".vel/" || ARGV.first
raise "directories must end with a /" unless DIR.match(/\/$/)
unless File.exist? DIR
  File.makedirs DIR
end

def time_prompt
  Time.now.strftime('%D') + ": "
end
def greeting
  "Aum tat sat aum"
end

log = Logger.new(DIR + 'legis')

log.info("Recording session started")

puts greeting
print time_prompt

while (input = gets.chomp) != ".."
  if (input.match(/^:/))
    log.debug(input)
  else
    log.warn(input)
  end
  print time_prompt
end

log.info("Recorded session ending")

puts greeting