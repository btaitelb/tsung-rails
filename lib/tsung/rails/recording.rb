require 'tsung/rails/platform'
require 'tsung/rails/config'
require 'nokogiri'

module Tsung
  module Rails
    module Recording
      def record
        puts "Hit Ctrl+C When Done"
        port = "8090"
        recording_file = nil

        Signal.trap("INT") do
        end

        require 'open3'
        Open3.popen2e("tsung-recorder", "-L", port, "start") { |input, output_error, wait_thread|
          output_error.each { |line|
            if line =~ /"Record file: (.*\.xml)"/
              recording_file = $1
              puts "#{line} [Detected Recording: #{recording_file}]"
            elsif line =~ /^BREAK: / || line =~ /\(v\)ersion/
              # ignore
            else
              puts "#{line}"
            end
          }
        }

        finish recording_file
      end

      def finish(recording_file)
        if recording_file.nil? || recording_file.empty?
          STDERR.puts "No recording detected."
        end

        recording_name = (ENV['RECORDING'] || File.basename(recording_file)).strip
        if !(recording_name =~ /\.xml$/)
          recording_name << ".xml"
        end

        recording = read_recording(recording_file)

        # TODO: move this to configuration param
        filtered_domains = ['.googleapis.com',
                            '.googleusercontent.com',
                            'safebrowsing.clients.google.com',
                            'safebrowsing-cache.google.com',
                            '.fxfeeds.mozilla.com',
                            '.newsrss.bbc.co.uk',
                            '.feeds.bbci.co.uk']

        remove_domains(recording, filtered_domains)
        update_session_name(recording, recording_name)
        fix_csrf_token(recording)
        add_random_content(recording)
        replace_object_ids(recording)

        save_recording(recording, recording_name)
        puts "Created #{recording_name}"
      end

      def remove_recording(recording_name)
        file = File.join(Tsung::Rails.recordings_dir, recording_name)
        if !(file =~ /\.xml$/)
          file << ".xml"
        end
        if File.delete(file)
          puts "Deleted recording #{recording_name}"
        end
      end


      private

      def create_recordings_dir
        `mkdir -p #{Tsung::Rails.recordings_dir}`
      end

      def save_recording(doc, recording_name)
        create_recordings_dir unless File.exist?(Tsung::Rails.recordings_dir)
        recording_file = "#{Tsung::Rails.recordings_dir}/#{recording_name}"

        # remove the opening <?xml version... as it's causing an error in playback
        xml = doc.to_s.gsub(/<\?xml version="1.0"\?>/, '')
        File.open(recording_file, 'w') {|f| f.write(xml)}
      end

      def list_recordings
        recordings = Dir[Tsung::Rails.recordings_dir + "/*.xml"].map{|f| File.basename(f).gsub(/\.xml$/, '')}
        puts recordings.join("\n")
        puts "\nTotal Recordings: #{recordings.length}"
      end

      def read_recording(recording_file)
        f = File.open(recording_file)
        doc = Nokogiri::XML(f)
        f.close

        doc
      end

      def remove_domains(recording, domains)
        domains.each do |domain|
          recording.xpath("//request/http[contains(@url, '#{domain}')]").each do |node|
            node.parent.unlink
          end
        end
      end

      def update_session_name(recording, recording_name)
        session_node = recording.xpath("//session").first
        session_node["name"] = recording_name.sub(/\.xml$/, '') if session_node
      end

      def fix_csrf_token(recording)
        recording.xpath("//request/http[@method = 'GET']").each do |node|
          node.before('<dyn_variable name="authenticity_token"/>')
        end
        recording.xpath("//request/http[contains(@contents, 'authenticity_token')]").each do |node|
          node.parent["subst"] = "true"
          contents = node["contents"]
          node["contents"] = contents.sub(/authenticity_token=[^&]*/, 'authenticity_token=%%tsung_rails:encoded_token%%')
        end
      end

      def add_random_content(recording)
        recording.xpath("//request/http[contains(@contents, '__random__')]").each do |node|
          node.parent["subst"] = "true"
          contents = node["contents"]
          node["contents"] = contents.sub(/=__random__/, '=%%tsung_rails:random%%')
        end
      end

      ## TODO: make this more robust
      #  currently, it'll assume that a POST followed by a GET to a similar url is a redirect,
      #  and will replace the hardcoded url with a dynamic variable bound to the redirect.
      #  This does not handle the case of subsequent POSTs, like for nested resources
      def replace_object_ids(recording)
        # capture _created_object_id for each POST
        recording.xpath("//request/http[@method = 'POST']").each do |node|
          node.before('<dyn_variable name="redirect" re="Location: (https?://.*)\r"/>')
        end

        # find GETs that look like redirects
        http_nodes = recording.xpath("//http")
        http_nodes.each_with_index do |node, i|
          if node['method'] == 'POST' && i < (http_nodes.length-1)
            next_node = http_nodes[i+1]
            next if next_node['method'] != 'GET'
            if next_node['url'] =~ /#{node['url']}\/([^\/]+)/
              next_node.parent['subst'] = 'true'
              next_node['url'] = '%%_redirect%%'
            end
          end
        end
      end

    end
  end
end
