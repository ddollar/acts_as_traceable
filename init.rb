require File.join(File.dirname(__FILE__), 'lib', 'acts_as_traceable')

class << Object
  include ActsAsTraceable
end