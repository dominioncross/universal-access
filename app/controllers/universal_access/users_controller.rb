# frozen_string_literal: true

require_dependency 'universal_access/application_controller'

module UniversalAccess
  class UsersController < ApplicationController
    def index
      # list users who have access to functions under the 'crm' category
      users = Universal::Configuration.class_name_user.classify.constantize.where('_ugf.crm.0' => { '$exists' => true })
      users = users.sort_by(&:name).map do |u|
        { name: u.name,
          email: u.email,
          first_name: u.name.split[0].titleize,
          id: u.id.to_s,
          functions: (u.user_group_functions.blank? ? [] : u.user_group_functions['crm']) }
      end
      render json: users
    end

    def autocomplete
      @users = Universal::Configuration.class_name_user.classify.constantize.all
      @users = @users.scoped_to(universal_scope) if Universal::Configuration.user_scoped
      @users = @users.full_text_search(params[:term], match: :all) if params[:term].present?
      json = @users.map { |c| { label: "#{c.name} - #{c.email}", value: c.id.to_s } }
      render json: json.to_json
    end
  end
end
