module Roleable
  extend ActiveSupport::Concern

  included do
    ROLES = %i[admin teacher student]

    store_accessor :roles, *ROLES

    ROLES.each do |role|
      scope role, -> { where('roles @> ?', { role => true }.to_json) }
      define_method(:"#{role}=") { |value| super ActiveRecord::Type::Boolean.new.cast(value) }
      define_method(:"#{role}?") { send(role) }
    end

    def active_roles
      ROLES.select { |role| send(:"#{role}?") }.compact
    end

    validate :must_have_a_role, on: :update
    validate :must_have_an_admin

    private

    def must_have_an_admin
      if persisted? &&
         (User.where.not(id:).pluck(:roles).count { |h| h['admin'] == true } < 1) &&
         roles_changed? && admin == false
        errors.add(:base, 'There should be at least one admin')
      end
    end

    def must_have_a_role
      return unless roles.values.none?

      errors.add(:base, 'A user must have at least one role')
    end
  end
end
