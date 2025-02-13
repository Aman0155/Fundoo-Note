require 'rails_helper'

RSpec.describe UserService do
  let(:user) { create(:user, password: "Password@123", phone_number: "9876543210") }

  describe ".createUser" do
    it "creates a user with valid parameters" do
      params = attributes_for(:user, password: "Password@123", phone_number: "9876543210")
      result = UserService.createUser(params)

      expect(result[:success]).to be true
      expect(result[:message]).to eq("User created successfully")
    end

    it "fails with invalid parameters" do
      params = { email: "", password: "" }
      result = UserService.createUser(params)

      expect(result[:success]).to be false
      expect(result[:errors]).to include("Email can't be blank")
    end
  end

  describe ".login" do
    it "logs in with valid credentials" do
      result = UserService.login(email: user.email, password: "Password@123")

      expect(result[:success]).to be true
      expect(result[:message]).to eq("Login successful")
      expect(result[:token]).not_to be_nil
    end

    it "fails with invalid email" do
      expect { UserService.login(email: "wrong@example.com", password: "Password@123") }
        .to raise_error(StandardError, "Invalid email")
    end

    it "fails with incorrect password" do
      expect { UserService.login(email: user.email, password: "WrongPass@123") }
        .to raise_error(StandardError, "Invalid password")
    end
  end

  describe ".forgetPassword" do
    before do
      allow(UserService).to receive(:send_otp_to_queue).and_return(true)
    end

    it "sends an OTP when email exists" do
      result = UserService.forgetPassword(email: user.email)

      expect(result[:success]).to be true
      expect(result[:message]).to match(/OTP has been sent to/)
    end

    it "fails when email is not found" do
      result = UserService.forgetPassword(email: "unknown@example.com")

      expect(result[:success]).to be false
    end
  end

  describe ".resetPassword" do
    before do
      allow(UserService).to receive(:send_otp_to_queue).and_return(true)
      UserService.forgetPassword(email: user.email)

      # Mock OTP and OTP time
      UserService.class_variable_set(:@@otp, 123456)
      UserService.class_variable_set(:@@otp_generated_at, Time.current - 10.seconds)
    end

    it "resets password with a valid OTP" do
      result = UserService.resetPassword(user.id, otp: 123456, new_password: "NewPassword@123")

      expect(result[:success]).to be true
    end

    it "fails with an invalid OTP" do
      result = UserService.resetPassword(user.id, otp: "999999", new_password: "NewPassword@123")

      expect(result[:success]).to be false
      expect(result[:errors]).to eq("Invalid OTP")
    end
  end
end
