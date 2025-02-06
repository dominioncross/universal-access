# frozen_string_literal: true

module UniversalAccess
  class ApplicationController < ::ApplicationController
    helper Universal::ApplicationHelper

    before_action :enforce_user_access

    def enforce_user_access
      return if universal_access_allowed

      render file: Rails.public_path.join('404.html').to_s, status: :not_found,
             layout: false
    end
  end
end
