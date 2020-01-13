module Zoho
  module Subscriptions
    class Hostedpage < ResourceBase
      resource_attributes :hostedpage_id,
                          :status,
                          :url,
                          :action,
                          :expiring_time,
                          :created_time,
                          :custom_fields,
                          :data

      class << self
        def find(id)
          response = Client.get "#{resource_path}/#{id}"

          case response.code
          when 200
            new response.as_json.slice(*attribute_names.map(&:to_s))
          when 404, 400 # Could be a bug in the API but currently when not found the response code is 400
            raise Errors::NotFound, "cannot find #{resource_name} with id:#{id} "
          else
            unexpected_response response
          end
        end

        def new_sub(attributes)
          response = Client.post '/hostedpages/newsubscription', body: attributes.to_json

          case response.code
          when 201
            new response[resource_name].slice(*attribute_names.map(&:to_s))
          else
            unexpected_response response
          end
        end
      end
    end
  end
end
