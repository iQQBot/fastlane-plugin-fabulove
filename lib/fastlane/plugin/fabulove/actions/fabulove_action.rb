require 'fastlane/action'
require_relative '../helper/fabulove_helper'
require 'httparty'

module Fastlane
  module Actions
    module SharedValues
        FABU_LOVE_VERSION_ID = :FABU_LOVE_VERSION_ID
    end
    class FabuloveAction < Action
      def self.run(params)
        UI.message("The fabulove plugin is working!")
        
        base_url = params[:base_url]
        team_id = params[:team_id]
        file_path = params[:file_path]

        self.upload_page(base_url, team_id, file_path)
        return 1
      end

      def self.upload_page (base_url, team_id, file_path)
        response = HTTParty.post("#{base_url}/upload?appId=#{team_id}",{
          :headers => {'accept'=>'application/json',  'Content-Type'=>'multipart/form-data'},
          :body => {ipa:File.open(file_path)}
        })
        UI.message "upload file success"
        return 1
      end

      def self.description
        "'fabulove' distribution system fastlane plugin"
      end

      def self.authors
        ["carry"]
      end

      def self.output
        [
          ['FABU_LOVE_VERSION_ID', 'The publish version id']
        ]
      end

      def self.return_type
        :string
      end

      def self.details
        # Optional:
        "'fabulove' distribution system fastlane plugin"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :base_url,
                                       env_name: "FL_FABULOVE_BASE_URL", # The name of the environment variable
                                       description: "You custom fabulove server url address.Example:https://gitlab.engineerhope.com:444", # a short description of this parameter
                                       is_string: true,
                                       default_value: nil),
          FastlaneCore::ConfigItem.new(key: :team_id,
                                       env_name: "FL_FABULOVE_TEAM_ID",
                                       description: "You fabulove team_id",
                                       is_string: true, # true: verifies the input is a string, false: every kind of value
                                       default_value: nil), # the default value if the user didn't provide one
          FastlaneCore::ConfigItem.new(key: :file_path,
                                       env_name: "FL_FABULOVE_FILE_PATH",
                                       description: "FILE APP PATH",
                                       default_value: nil,
                                       optional: true)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
