module Api
  module V1
    class UsersController < ApplicationController
      before_action :authorize_request, except: [:userLogin, :create]

      def index
        users = UserService.get_users
        render json: users, status: :ok
      end

      def show
        user = UserService.get_user(params[:id])
        if user
          render json: user, status: :ok
        else
          render json: { error: "User not found" }, status: :not_found
        end
      end

      def create
        result = UserService.create_user(user_params)
        if result[:success]
          render json: result[:user], status: :created
        else
          render json: { errors: result[:errors] }, status: :unprocessable_entity
        end
      end

      def destroy
        result = UserService.delete_user(params[:id])
        if result[:success]
          render json: { message: result[:message] }, status: :ok
        else
          render json: { error: result[:error] }, status: :not_found
        end
      end

      def userLogin
        result = UserService.login_user(params[:email], params[:password])
        if result[:success]
          render json: { token: result[:token], message: result[:message] }, status: :ok
        else
          render json: { error: result[:error] }, status: :unauthorized
        end
      end

      private

      def user_params
        params.permit(:name, :email, :phone_number, :password, :password_confirmation)
      end
    end
  end
end
