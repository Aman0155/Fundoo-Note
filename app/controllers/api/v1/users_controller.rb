class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  rescue_from StandardError, with: :handle_login_error

  def createUser
    result = UserService.createUser(user_params)
    if result[:success]
      render json: { message: result[:message] }, status: :created
    else 
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def login
    result = UserService.login(login_params)
    render json: { message: result[:message], token: result[:token] }, status: :ok
  end 

  def forgetPassword
    result = UserService.forgetPassword(fp_params)
    if result[:success]
      render json: { message: result[:message] }, status: :ok
    else
      render json: { errors: result[:errors] }, status: :bad_request
    end
  end

  def resetPassword
    user_id = params[:id]
    result = UserService.resetPassword(user_id, rp_params)
    if result[:success]
      render json: { message: result[:message] }, status: :ok
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  private 

  def user_params
    params.require(:user).permit(:name, :email, :password, :phone_number)
  end

  def login_params
    params.require(:user).permit(:email, :password)
  end

  def fp_params
    params.require(:user).permit(:email)
  end

  def rp_params
    params.require(:user).permit(:new_password, :otp)
  end

  def handle_login_error(exception)
    render json: { errors: exception.message }, status: :bad_request
  end
end
