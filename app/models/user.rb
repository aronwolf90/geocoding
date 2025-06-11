class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  enum :geolocation_process_status, {
    undefined: "undefined",
    succeeded: "succeeded",
    failed: "failed"
  }

  geocoded_by :address do
    User.assign_geocode_result(_1, _2)
  end

  normalizes :email_address, with: -> { _1.strip.downcase }
  normalizes :street, with: -> { _1.strip }
  normalizes :zip_code, with: -> { _1.strip }

  validates :email_address, presence: true, uniqueness: true
  validates :street, presence: true
  validates :zip_code, presence: true
  validates :city, presence: true
  validates :country, presence: true

  after_commit :async_geocode_address, if: :saved_change_to_address?

  def address
    "#{street}, #{zip_code} #{city}, #{country}"
  end

  def geocode!
    geocode

    if latitude.present? && longitude.present?
      update!(geolocation_process_status: "succeeded")
    else
      update!(geolocation_process_status: "failed")
    end
  end

  # @private
  def self.assign_geocode_result(user, results)
    result = results.first

    if result.present?
      user.latitude = result.latitude
      user.longitude = result.longitude
      user.state = result.state
    else
      user.latitude = nil
      user.longitude = nil
      user.state = nil
    end
  end

  private
    def async_geocode_address
      GeocodeJob.perform_later(self)
    end

    def saved_change_to_address?
       saved_change_to_street? ||
         saved_change_to_zip_code? ||
         saved_change_to_city? ||
         saved_change_to_country?
    end
end
