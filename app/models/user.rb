class User < ApplicationRecord
  def self.from_google_login(google_user)
    # Retrieve relevant User or create a new one if necessary
    user = User.where(user_id: google_user.user_id).first_or_initialize
    user.name = google_user.name
    user.email = google_user.email_address
    user.profile_img = google_user.avatar_url.gsub(/s96/, "s32")
    user.save! if user.changed?
    return user
  end
end
