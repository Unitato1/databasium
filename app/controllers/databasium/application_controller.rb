module Databasium
  class ApplicationController < ActionController::Base
    helper ::Databasium::HeroiconHelper

    layout -> { Views::Layouts::Databasium::Application.new }
  end
end
