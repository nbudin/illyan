module PersonSessionsHelper
  def person_sessions_stylesheet
    "<link rel=\"stylesheet\" href=\"#{person_sessions_url(:format => :css)}\" />"
  end
end
