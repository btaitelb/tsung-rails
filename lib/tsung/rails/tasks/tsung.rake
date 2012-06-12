require 'tsung/rails/platform'
require 'tsung/rails/checks'
require 'tsung/rails/playback'
require 'tsung/rails/recording'

namespace :tsung do

  desc "Check for tsung installation"
  task :check do
    include Tsung::Rails::Checks
    check_tsung
    check_tsung_recorder
    check_tsung_stats
  end

  desc "Launch the tsung recording proxy. Use RECORDING environment variable to name the recording."
  task :record do
    include Tsung::Rails::Recording
    record
  end

  namespace :recordings do
    desc "List current recordings used by the app"
    task :list do
      include Tsung::Rails::Recording
      list_recordings
    end

    desc "Remove recording named in RECORDING environment variable"
    task :remove do
      include Tsung::Rails::Recording
      if !ENV['RECORDING'] || ENV['RECORDING'].empty?
        STDERR.puts "Missing RECORDING environment variable."
      else
        remove_recording(ENV['RECORDING'])
      end
    end
  end

  desc "Playback the tsung recordings"
  task :play do
    include Tsung::Rails::Playback
    playback
  end
end
