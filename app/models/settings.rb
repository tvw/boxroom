class Settings < Settingslogic
  source "#{RAILS_ROOT}/config/application.yml"
  namespace RAILS_ENV
end
