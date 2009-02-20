#!/usr/bin/ruby

# load required libraries
require 'ftools'
require 'logger'

# set up environment
DIR = ARGV.first || ".vel/"
ARGV.clear # ruby idiosyncracy. needed so "gets" works later. 
raise "directories must end with a /" unless DIR.match(/\/$/)
unless File.exist? DIR
  File.makedirs DIR
end

# hooks
def proclaim(utterance); end
def whisper(utterance); end
def invoke(utterance); end
def say(utterance); end
def prompt; end
def greeting; end

# let there be light
begin
  load DIR + 'spells'
rescue LoadError
  god = "def create(spell); conjuration = File.new(DIR + 'spells', 'a'); conjuration.puts spell; instance_eval spell; end"
  instance_eval god
  create god
  
  # for ones convinience
  create "def invoke(utterance); spell = utterance[1..-1]; eval spell; end"
  create "def prompt; Time.now.strftime('%D') + ': '; end"
  create "def greeting; 'Aum tat sat aum'; end"
ensure
  log = Logger.new(DIR + 'legis')
  log.info("Recording session started")
  begin # recording incantations
    puts greeting
    print prompt
    while (input = gets.chomp) != ".."
      if input.match /^#/
        log.fatal(input)
        proclaim(input)
      elsif input.match /^\//
        log.warn(input)
        whisper(input)
      elsif input.match /^:/
        log.debug(input)
        invoke(input)
      else
        log.error(input)
        say(input)
      end
      print prompt
    end
    puts greeting
  rescue # vanishing demon will
    log.info("Failure")
    puts "failure"
  end
  log.info("Recorded session ending")
end