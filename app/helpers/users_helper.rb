module UsersHelper
  def user_geolocated_attribute(user, field)
    case user.geolocation_process_status
    when "failed"
      "Failed to get #{field} by geolocation"
    when "succeeded"
      user.public_send(field)
    when "undefined"
      "Processing geolocation. Pleas try again later."
    end
  end
end
