Dir["#{File.dirname(__FILE__)}/super_settings/**/*.rb"].each do |file|
  require(file)
end

# This is the main SuperSettings module.
# SuperSettings allows a user to define
# Backend agnostic settings, rules and operations
module SuperSettings
end
