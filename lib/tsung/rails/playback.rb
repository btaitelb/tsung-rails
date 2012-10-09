require 'tsung/rails/platform'
require 'tsung/rails/config'

module Tsung
  module Rails
    module Playback

      def playback
        puts "Playing back #{Tsung::Rails.playback_file}"
        prepare_playback

        erl_libs = "#{ENV['ERL_LIBS']}:#{Tsung::Rails.results_dir}"
        env = { 'ERL_LIBS' => erl_libs }

        require 'open3'
        Open3.popen2e(env, 'tsung', '-f', Tsung::Rails.playback_file, 'start') { |input, output_error, wait_thread|
          output_error.each { |line|
            puts line
            if line =~ /Log directory is: ([^"]*)/
              log_dir = $1
              puts " [Captured log directory: #{log_dir}]"
            end
          }
        }

        # play each recording, determinining its throughput
        # plot all recordings on the same summary graph
      end

      def finish_playback
        puts "done with playback"
      end

      private

      def prepare_playback
        create_results_dir
        create_playback_file
        copy_erlang_binaries
      end

      def create_playback_file(arrival_time_in_seconds = 1, duration_in_seconds = 30)
        template = File.open(Tsung::Rails.template_file, "rb").read
        template.gsub!('__RECORDING__', recording_file.to_s)
        template.gsub!('__ARRIVAL_TIME_IN_SECONDS__', arrival_time_in_seconds.to_s)
        template.gsub!('__DURATION_IN_SECONDS__', duration_in_seconds.to_s)

        # TODO: figure out who the server is and update the file

        unless File.exists?(Tsung::Rails.playback_file)
          File.open(Tsung::Rails.playback_file, 'w') {|f| f.write(template)}
        end
      end

      def create_results_dir
        `mkdir -p #{Tsung::Rails.results_dir}`
      end

      def copy_erlang_binaries
        `mkdir -p #{Tsung::Rails.results_dir}/ebin`
        `cp #{Tsung::Rails.erlang_dir}/*.beam #{Tsung::Rails.results_dir}/ebin`
      end

      def recording_file
        recording = ENV['RECORDING']
        if recording && !recording.empty?
          recording = File.join(Tsung::Rails.recordings_dir, recording)
          if !(recording =~ /\.xml$/)
            recording << ".xml"
          end
        else
          recording = Dir.glob(File.join(Tsung::Rails.recordings_dir, '*.xml')).max_by{|f| File.mtime(f)}
        end

        recording
      end
    end
  end
end
