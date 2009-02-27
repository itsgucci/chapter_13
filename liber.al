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
def initiation; end
def proclaim(utterance); end
def whisper(utterance); end
def invoke(utterance); end
def say(utterance); end
def omni(utterance); end
def epilogue; end

# let there be light
begin
  load DIR + 'spells'
rescue LoadError
  god = "def create(spell); File.open(DIR + 'spells', 'a') {|conjuration| conjuration.puts spell}; instance_eval spell; end"
  instance_eval god
  create god
  
  # for ones convinience
  create "def invoke(utterance); spell = utterance[1..-1]; eval spell; end"
  create "def challenge; print Time.now.strftime('%D') + ': '; end"
  create "def incantation; challenge; gets.chomp; end"
  create "def initiation; puts 'Aum tat sat aum'; end"
ensure
  log = Logger.new(DIR + 'legis')
  log.info("Recording session started")
  begin # recording incantations
    initiation
    while (command = incantation) != ".."
      #this will be terser
      if command.match /^!/
        log.fatal(command)
        proclaim(command)
      elsif command.match /^,/
        log.warn(command)
        whisper(command)
      elsif command.match /^:/
        log.debug(command)
        invoke(command)
      else
        log.error(command)
        say(command)
      end
      omni(command)
    end
    epilogue
  rescue Exception => demon
    log.info("Failure | #{demon} | #{command}")
    puts "failure by #{demon}"
  end
  log.info("Recorded session ending")
end