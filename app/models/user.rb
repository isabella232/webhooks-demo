class User < ApplicationRecord
  before_create :generate_verification_code
  after_create :send_verification_postcard
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  private

  def generate_verification_code
    self.verification_code = SecureRandom.hex(6)
  end

  def send_verification_postcard
    PostcardWorker.perform_async(self.id)
  end
end
