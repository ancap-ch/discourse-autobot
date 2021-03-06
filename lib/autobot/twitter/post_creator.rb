module Autobot
  module Twitter
    class PostCreator < Autobot::PostCreator

      def initialize(campaign, tweet)
        super(campaign)
        @tweet = tweet
      end

      def title
        return "[#{full_name}](#{source_url})" unless new_topic?

        "#{full_name} on Twitter - #{content}"[0..SiteSetting.max_topic_title_length]
      end

      def content
        @tweet["text"]
      end

      def source_url
        "https://twitter.com/#{user["screen_name"]}/status/#{@tweet["id"]}"
      end

      def image_url
        media["media_url_https"] if media.present?
      end

      def update_campaign(value)
        value["since_id"] = @tweet["id"] if value["since_id"].present? && value["since_id"].to_i < @tweet["id"]
        super
      end

      private

        def full_name
          "#{user["name"]} (#{user["screen_name"]})"
        end

        def user
          @tweet["user"]
        end

        def media
          @tweet["entities"]["media"]
        end

    end
  end
end
