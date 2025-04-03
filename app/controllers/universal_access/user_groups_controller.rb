# frozen_string_literal: true

require_dependency 'universal_access/application_controller'

module UniversalAccess
  class UserGroupsController < ApplicationController
    before_action :find_group, only: %i[users add_user remove_user edit update show destroy]

    def index
      @user_groups = find_user_groups
    end

    def show
      render_show @user_group
    end

    def edit
      # load the functions
      @functions = YAML.safe_load(File.read(Rails.root.join('config/universal_access_functions.yml').to_s)).symbolize_keys
    end

    def create
      @user_group = ::Universal::UserGroup.new(user_group_params)
      @user_group.scope = universal_scope
      @user_group.functions = params[:functions]
      @user_groups = find_user_groups if @user_group.save
      redirect_to universal_access.edit_user_group_path(@user_group)
    end

    def users
      @users = @user_group.users.ordered
      render layout: false
    end

    def add_user
      @user = Universal::Configuration.class_name_user.classify.constantize.find(params[:user_id])
      @user&.set_user_group!(@user_group)
      @users = @user_group.users
      render layout: false
    end

    def remove_user
      @user = Universal::Configuration.class_name_user.classify.constantize.find(params[:user_id])
      @user.set_user_group!(@user_group, false)
      render layout: false
    end

    def update
      @user_group.functions = params[:functions].to_unsafe_h
      @user_group.save
      redirect_to universal_access.user_groups_path
    end

    def destroy
      @user_group&.users&.map do |u|
        u.pull(_ugid: @user_group.id.to_s)
        u.update_user_group_functions
      end
      redirect_to universal_access.user_groups_path
    end

    private

    def user_group_params
      params.require(:user_group).permit(:name, :notes)
    end

    def find_group
      @user_group = ::Universal::UserGroup.find(params[:id])
    end

    def find_user_groups
      g = ::Universal::UserGroup.all
      g = g.scoped_to(universal_scope) unless universal_scope.nil?
      g
    end
  end
end
