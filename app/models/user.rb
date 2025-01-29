class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/, message: "Must be a valid email" }
  validates :password, presence: true, format: {
    with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()])[A-Za-z\d!@#$%^&*()]{8,12}\z/,
    message: "Password must be at least 8 characters long, include an uppercase letter, a number, and a special character."
  }
  validates :phone_number, presence: true, uniqueness: true, format: { with: /\A[+]?[6-9]\d{9,14}\z/, message: "Must be a valid phone number" }
end
