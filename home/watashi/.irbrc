# .irbrc - last change: 2008-01-22 (ab)




require 'prime'





### rubygems
require 'rubygems' rescue nil

### pretty print
require 'pp'

### less verbose prompt

#IRB.conf[:PROMPT_MODE] = :SIMPLE

IRB.conf[:PROMPT][:SHORT] = {
  :PROMPT_C => "%03n:%i* ",
  :RETURN   => "%s\n",
  :PROMPT_I => "%03n:%i> ",
  :PROMPT_N => "%03n:%i ",
  :PROMPT_S => "%03n:%i%l "
}
#IRB.conf[:PROMPT_MODE] = :SHORT

### automatic indentation
IRB.conf[:AUTO_INDENT] = true

### tab completion
require 'irb/completion'
IRB.conf[:USE_READLINE] = true

### preserve history
require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:EVAL_HISTORY] = 100

### syntax highlighting
require 'wirble'
Wirble.init(:skip_prompt => true, :skip_history => true)
Wirble.colorize

### irb session duration
require 'duration'
IRB_START_TIME = Time.now
at_exit { puts "\nirb session duration: #{Duration.new(Time.now - IRB_START_TIME)}" }

### aliases
alias r require

### easy YAML
def y(*data); require 'yaml'; puts YAML::dump(*data); end

### Object#tap
class Object; def tap; yield self; self; end; end

### map by method
# http://drnicwilliams.com/2006/10/04/i-love-map-by-pluralisation/
require 'map_by_method'

### method finder, e.g. "foo".what?
# http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/32844
# http://www.nobugs.org/developer/ruby/method_finder.html
# http://redhanded.hobix.com/inspect/stickItInYourIrbrcMethodfinder.html
require 'what_methods'

### gaining temporary access to private methods
# http://blog.jayfields.com/2007/11/ruby-testing-private-methods.html
class Class
  def publicize_methods
    saved_private_instance_methods = self.private_instance_methods
    self.class_eval { public *saved_private_instance_methods }
    yield
    self.class_eval { private *saved_private_instance_methods }
  end
end

### System-wide script/console logging
# http://toolmantim.com/article/2007/2/6/system_wide_script_console_logging
script_console_running = ENV.include?('RAILS_ENV') && IRB.conf[:LOAD_MODULES] && IRB.conf[:LOAD_MODULES].include?('console_with_helpers')
rails_running = ENV.include?('RAILS_ENV') && !(IRB.conf[:LOAD_MODULES] && IRB.conf[:LOAD_MODULES].include?('console_with_helpers'))
irb_standalone_running = !script_console_running && !rails_running

if script_console_running
  require 'logger'
  Object.const_set(:RAILS_DEFAULT_LOGGER, Logger.new(STDOUT))
end

### different history file for rails
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history_rails" unless irb_standalone_running
