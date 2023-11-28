# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ApplicationHelper
  before_action :authenticate_user!
end
