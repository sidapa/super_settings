module SuperSettings
  # This class allows for feature toggles
  class FeatureSet
    extend SuperSettings::AllowRegistration
    extend SuperSettings::AllowMethodMissingOverride

    # TODO: create a class that deals with contexts
  end
end
