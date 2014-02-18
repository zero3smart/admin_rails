module Api
  module V1
    class Api::V1::ApplicationController < ActionController::Base
      respond_to :json


      def update
        user = User.where(id: params[:id], auth_token: params[:user][:auth_token]).first
        if user
          if user.update(user_params_change)
            render json: {}, status: 200
          else
            render json: { error_info: { code: 101, title: '', message: user.errors.full_messages.join(", ") } }, status: 422
          end
        else
          render json: { error_info: { code: 103, title: '',  message: "Invalid authentication token" } }, status: 401
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :phone, :email, :password)
      end

      def user_params_change
        params.require(:user).permit(:name, :email)
      end
    end
  end
end

