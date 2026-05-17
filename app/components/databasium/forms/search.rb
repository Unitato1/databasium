# frozen_string_literal: true

module Components
  module Databasium
    class Forms::Search < Components::Base
      include Phlex::Rails::Helpers::FormWith

      def initialize(url:, turbo_frame:, placeholder:)
        @url = url
        @turbo_frame = turbo_frame
        @placeholder = placeholder
      end

      def view_template
        div(data: { controller: "search" }) do
          form_with url: @url,
                    method: :get,
                    data: {
                      turbo_frame: @turbo_frame,
                      action: "input->search#update"
                    } do |form|
            raw form.search_field :search,
                                  class:
                                    "border-2 border-border bg-background rounded-md p-2 w-full",
                                  placeholder: @placeholder
          end
        end
      end
    end
  end
end
