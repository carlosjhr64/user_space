require 'rainbow'
# TODO: Come up with some good cucumber tests.
Given /^(\w+) (.*)$/ do |given, condition|
  condition.strip!
  case given
  when 'Given'
    #raise "'Given' form not defined."
    STDERR.puts "Need to come up with some cucumber tests".color(:blue)
  when 'When'
    #raise "'When' form not defined."
    STDERR.puts "Need to come up with some cucumber tests".color(:blue)
  when 'Then'
    #raise "'Then' form not defined."
    STDERR.puts "Need to come up with some cucumber tests".color(:blue)
  else
    raise "'#{given}' form not defined."
  end
end
