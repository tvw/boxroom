require 'fileutils'

namespace :app do
  desc "Restart application, when deployed with Phusion Passenger"
  task :restart do
    FileUtils.touch "#{RAILS_ROOT}/tmp/restart.txt"
  end
end
