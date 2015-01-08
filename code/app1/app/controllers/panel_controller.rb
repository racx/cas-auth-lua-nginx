require 'base64'
class PanelController < ApplicationController
  before_filter :authorize
  def index
  end

  private

  def authorize
    @user = Base64.decode64(cookies[:usrid])
    (render text: 'Unauthorized access', status: 401;return) if @user.nil?

  end
  
end
