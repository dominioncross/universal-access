require_dependency "universal_access/application_controller"

module UniversalAccess
  class UserGroupsController < ApplicationController

    before_action :find_group, only: [:users, :add_user, :remove_user, :edit, :update, :show, :destroy]

    def index
      @user_groups = find_user_groups
    end

    def create
      @user_group = ::Universal::UserGroup.new(user_group_params)
      @user_group.scope = universal_scope
      @user_group.functions = params[:functions]
      if @user_group.save
        @user_groups = find_user_groups
      end
      redirect_to universal_access.edit_user_group_path(@user_group)
    end

    def show
      render_show @user_group
    end

    def users
      @users = @user_group.users.ordered
      render layout: false
    end

    def add_user
      @user = Universal::Configuration.class_name_user.classify.constantize.find(params[:user_id])
      @user.set_user_group!(@user_group) if !@user.nil?
      @users = @user_group.users
      render layout: false
    end

    def remove_user
      @user = Universal::Configuration.class_name_user.classify.constantize.find(params[:user_id])
      @user.set_user_group!(@user_group, false)
      render layout: false
    end

    def edit
      #load the functions
      @functions = YAML.load(File.read("#{Rails.root}/config/universal_access_functions.yml")).symbolize_keys
    end

    def update
      @user_group.functions = params[:functions].to_unsafe_h
      if @user_group.update!(user_group_params)
      end
      redirect_to universal_access.user_groups_path
    end

    def destroy
      if !@user_group.nil?
        @user_group.users.map{|u| u.pull(_ugid: @user_group.id.to_s);u.update_user_group_functions}
        if @user_group.destroy!

        end
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
      g = g.scoped_to(universal_scope) if !universal_scope.nil?
      return g
    end

  end
end
