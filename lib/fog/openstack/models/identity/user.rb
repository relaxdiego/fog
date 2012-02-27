require 'fog/core/model'

module Fog
  module Identity
    class OpenStack
      class User < Fog::Model
        identity :id

        attribute :email
        attribute :enabled
        attribute :name
        attribute :tenantId
        attribute :password

        attr_accessor :email, :name, :tenantId, :enabled, :password

        def initialize(attributes)
          @connection = attributes[:connection]
          attributes[:enabled] ||= true
          super
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          requires :name, :tenantId, :password
          data = connection.create_user(name, password, email, tenantId, enabled)
          merge_attributes(data.body['user'])
          true
        end

        def update(options = {})
          requires :id
          options.merge('id' => id)
          response = connection.update_user(id, options)
          true
        end

        def update_password(password)
          update({'password' => password, 'url' => "/users/#{id}/OS-KSADM/password"})
        end

        def update_tenant(tenant)
          tenant = tenant.id if tenant.class != String
          update({:tenantId => tenant, 'url' => "/users/#{id}/OS-KSADM/tenant"})
        end

        def update_enabled(enabled)
          update({:enabled => enabled, 'url' => "/users/#{id}/OS-KSADM/enabled"})
        end

        def destroy
          requires :id
          connection.delete_user(id)
          true
        end

        def roles
          return Array.new unless tenantId
          tenant = Fog::Identity::OpenStack::Tenant.
            new(connection.get_tenant(tenantId).body['tenant'])

          connection.roles(
            :tenant => tenant,
            :user   => self)
        end
      end # class User
    end # class OpenStack
  end # module Identity
end # module Fog

