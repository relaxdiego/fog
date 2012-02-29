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

        def find_by_name(name)
          find_attribute(__method__, name)
        end

        def find_by_container_format(format)
          find_attribute(__method__, format)
        end

        def find_by_disk_format(format)
          find_attribute(__method__, format)
        end

        def find_by_status(status)
          find_attribute(__method__, status)
        end

        def find_by_size_min(size)
          find_attribute(__method__, size)
        end

        def find_by_size_max(size)
          find_attribute(__method__, size)
        end

        def find_attribute(attribute,value)
          attribute = attribute.to_s.gsub("find_by_", "")
          load(connection.list_public_images_detailed(attribute , value).body['images'])
        end
      end
    end
  end
end
