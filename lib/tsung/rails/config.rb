require 'active_support/core_ext'

module Tsung
  module Rails

    class << self
      def config
        @@config ||= Tsung::Rails::Config
      end

      [:recordings_dir, :template_file, :erlang_dir, :playback_file, :results_dir].each do |method|
        delegate method, "#{method}=".to_sym, :to => :config
      end
    end


    class Config
      class << self
        attr_accessor :recordings_dir, :template_file, :playback_file, :results_dir

        def recordings_dir
          @recordings_dir ||= default_recordings_dir
        end

        def template_file
          @template_file ||= default_template_file
        end

        def erlang_dir
          @erlang_dir ||= default_erlang_dir
        end

        def playback_file
          @playback_file ||= default_playback_file
        end

        def results_dir
          @results_dir ||= default_results_dir
        end

        def default_recordings_dir
          if defined?(::Rails) && ::Rails.root
            "#{::Rails.root}/recordings"
          else
            File.expand_path('./recordings')
          end
        end

        def default_template_file
          File.join(File.dirname(__FILE__), '..', '..', '..', 'templates', 'tsung.xml')
        end

        def default_erlang_dir
          File.join(File.dirname(__FILE__), '..', '..', '..', 'erlang')
        end

        def default_playback_file
          File.join(results_dir, 'tsung.xml')
        end

        def default_results_dir
          if defined?(::Rails)
            "#{::Rails.root/results}"
          else
            File.expand_path('./results')
          end
        end

      end
    end
  end
end
