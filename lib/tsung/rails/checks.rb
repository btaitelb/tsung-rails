require 'tsung/rails/platform'

module Tsung
  module Rails
    module Checks

      def check_tsung
        if tsung_version.empty?
          raise "tsung executable not found in PATH"
        else
          puts "Found tsung (#{tsung_version})"
        end
      end

      def check_tsung_recorder
        if tsung_recorder_version.empty?
          raise "tsung-recorder executable not found in PATH"
        else
          puts "Found tsung-recorder (#{tsung_recorder_version})"
        end
      end

      def check_tsung_stats
        if TSUNG_LIB_BIN_DIR.empty?
          raise "TSUNG_LIB_BIN_DIR is not set for this platform, so I don't know where tsung_stats.pl is. Please help by updating tsung-rails/lib/tsung/rails/platform.rb"
        end
        if tsung_stats_version.empty?
          raise "Error executing #{tsung_stats_version_cmd}"
        else
          puts "Found tsung_stats (#{tsung_stats_version})"
        end
      end

      def tsung_version
        @tsung_version ||= `tsung -v`.strip
      end

      def tsung_recorder_version
        @tsung_recorder_version ||= `tsung-recorder -v`.strip
      end

      def tsung_stats_version
        @tsung_stats_version ||= `#{TSUNG_LIB_BIN_DIR}/tsung_stats.pl --version`.lines.first.strip
      end
    end
  end
end
