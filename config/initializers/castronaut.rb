module Illyan
  class CastronautConfiguration
    def logger
      Rails.logger
    end
  end
end

Castronaut.config = Illyan::CastronautConfiguration.new