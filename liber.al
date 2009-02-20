#!/usr/bin/ruby

require 'ftools'
require 'logger'

DIR = ARGV.first || ".vel/"
ARGV.clear # needed so gets works later. ruby idiosyncracy. 
raise "directories must end with a /" unless DIR.match(/\/$/)
unless File.exist? DIR
  File.makedirs DIR
end

def invoke(utterance)
  spell = utterance[1..-1]
  eval spell
end
def time_prompt
  Time.now.strftime('%D') + ": "
end
def greeting
  "Aum tat sat aum"
end

begin
  load DIR + 'spells'
rescue LoadError
  god = "def create(spell); conjuration = File.new(DIR + 'spells', 'a'); conjuration.puts spell; instance_eval spell; end"
  instance_eval god
  create god
ensure
  log = Logger.new(DIR + 'legis')

  log.info("Recording session started")

  puts greeting
  print time_prompt

  while (input = gets.chomp) != ".."
    if input.match /^#/
      log.fatal(input)
    elsif input.match /^\//
      log.warn(input)
    elsif input.match /^:/
      log.debug(input)
      invoke(input)
    else
      log.error(input)
    end
    print time_prompt
  end

  log.info("Recorded session ending")

  puts greeting
end