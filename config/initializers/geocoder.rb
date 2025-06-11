# frozen_string_literal: true

if Rails.env.test?
  Geocoder.configure(lookup: :test, ip_lookup: :test)
end
