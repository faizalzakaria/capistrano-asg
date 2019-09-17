# frozen_string_literal: true

module Capistrano
  module Asg
    module Aws
      module Credentials
        extend ActiveSupport::Concern
        include Capistrano::DSL

        def credentials
          if fetch(:aws_profile)
            begin
              credentials = ::Aws::SharedCredentials.new(profile_name: fetch(:aws_profile)).credentials
              if credentials
                set :aws_access_key_id, credentials.access_key_id
                set :aws_secret_access_key, credentials.secret_access_key
              end
            rescue
              puts "Failed to retrieve AWS Profile, try env"
            end
          end

          access_key_id = fetch(:aws_access_key_id, ENV['AWS_ACCESS_KEY_ID'])
          secret_access_key = fetch(:aws_secret_access_key, ENV['AWS_SECRET_ACCESS_KEY'])

          ::Aws::Credentials.new(access_key_id, secret_access_key)
        end
      end
    end
  end
end
