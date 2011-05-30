module Nephophobia
  class Util
    ##
    # Wraps a Hash with an Array.
    #
    # +obj+: The Object to be tested for wrapping.

    def self.coerce obj
      (obj.is_a? Hash) ? [obj] : obj
    end
  end
end
