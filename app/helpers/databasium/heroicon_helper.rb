# frozen_string_literal: true

module Databasium
  module HeroiconHelper
    def heroicon(name, variant: Heroicon.configuration.variant, options: {}, path_options: {})
      svg =
        Heroicon::Icon.render(
          name: name,
          variant: variant,
          options: options,
          path_options: path_options
        ).to_s

      if respond_to?(:safe)
        raw safe(svg)
      else
        svg.html_safe
      end
    end
  end
end
