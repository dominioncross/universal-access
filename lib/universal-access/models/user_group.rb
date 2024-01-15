module UniversalAccess
  module Models
    module UserGroup
      extend ActiveSupport::Concern

      included do
        include Mongoid::Document

        include Universal::Concerns::Scoped

        store_in collection: UniversalAccess::Configuration.user_group_collection

        field :code
        field :name
        field :notes
        field :functions, type: Hash, default: {}
        field :locked, type: Mongoid::Boolean, default: false

        before_validation :update_relations

        validates_presence_of :code, :name

        default_scope -> { order_by(name: :asc) }
        scope :for_codes, ->(codes) { where(:code.in => codes.map(&:to_s)) }

        after_update :update_user_functions

        def users
          Universal::Configuration.class_name_user.classify.constantize.where(_ugid: id.to_s)
        end

        def update_user_functions
          users = Universal::Configuration.class_name_user.classify.constantize.where(_ugid: id.to_s)
          users.map(&:update_user_group_functions!)
        end

        private

        def update_relations
          self.code = name.parameterize.underscore if code.blank? && !name.blank?
        end
      end
    end
  end
end
