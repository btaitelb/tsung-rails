module Tsung
  module Rails
    class Railtie < ::Rails::Railtie
      # TODO: allow configuration from rails (then share it with app)
      # config.tsung_rails = ActiveSupport::OrderedOptions.new
      #initalizer "tsung-rails.configure" do |app|
      #  # TODO: set app configuration here
      #end

      rake_tasks do
        load "tsung/rails/tasks/tsung.rake"
      end

    end
  end
end

