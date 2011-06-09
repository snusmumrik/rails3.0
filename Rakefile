# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

# If you face "Undefined method 'task'" error using rake 0.9.0
#
# module ::Rails3
#   class Application
#     include Rake::DSL
#   end
# end

# module ::RakeFileUtils
#   extend Rake::FileUtilsExt
# end

Rails3::Application.load_tasks
