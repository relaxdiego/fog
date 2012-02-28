require 'fog/core/collection'
require 'fog/openstack/models/image/image'

module Fog
  module Image
    class OpenStack
      class Images < Fog::Collection
        model Fog::Image::OpenStack::Image

        def all
          load(connection.list_public_images_detailed.body['images'])
        end

        def details
          load(connection.list_public_images_detailed.body['images'])
        end

        def find_by_id(id)
          self.find {|image| image.id == id}
        end

        def public
          images = load(connection.list_public_images_detailed.body['images'])
          images.delete_if{|image| image.is_public == false}
        end

        def private
          images = load(connection.list_public_images_detailed.body['images'])
          images.delete_if{|image| image.is_public}
        end

        def destroy(id)
          image = self.find_by_id(id)
          image.destroy
        end

#        queries available through image service
#        find_by_container_format=FORMAT
#        find_by_disk_format=FORMAT
#        find_by_status=STATUS
#        find_by_size_min=BYTES
#        find_by_size_max=BYTES

        def method_missing(method_sym, *arguments, &block)
          if method_sym.to_s =~ /^find_by_(.*)$/
            load(connection.list_public_images_detailed($1 ,arguments.first).body['images'])
          else
            super
          end
        end

      end
    end
  end
end
