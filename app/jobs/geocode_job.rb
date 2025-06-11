class GeocodeJob < ApplicationJob
  def perform(user)
    user.geocode!
  end
end
