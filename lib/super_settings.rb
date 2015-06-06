current_directory = File.dirname(__FILE__)

%w(/super_settings/*.rb /super_settings/feature_set_parsers/*.rb).each do |dir|
  Dir[current_directory + dir].each { |file| require file }
end

# This is the main SuperSettings module.
# SuperSettings allows a user to define
# Backend agnostic settings, rules and operations
module SuperSettings
end
