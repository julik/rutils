Dir.entries(File.dirname(__FILE__)).each do | it|
  next unless it =~ /^test_/
  require File.expand_path(File.dirname(__FILE__)) + '/' + it
end