require 'spec_helper'
require 'tsung/rails/config'

describe Tsung::Rails::Config do
  subject{Tsung::Rails::Config}

  describe "#recordings_dir" do
    after(:each) do
      subject.recordings_dir = nil
    end

    context "rails" do
      before(:each) do
        unless defined?(::Rails)
          @mocked_rails_class = true
          class ::Rails
          end
        end
      end

      after(:each) do
        Object.send(:remove_const, :Rails) if @mocked_rails_class
      end

      it "is relative to the rails root" do
        ::Rails.should_receive(:root).twice.and_return("/rails")
        subject.recordings_dir #.should == "/rails/recordings"
      end
    end

    context "no rails" do
      it "is relative to the current directory" do
        ::Rails.should_receive(:root).and_return(nil)
        subject.recordings_dir.should == File.expand_path('./recordings')
      end
    end
  end

end

describe "Tsung::Rails" do
  describe "#config" do
    it "is a Tsung::Rails::Config" do
      Tsung::Rails.config.should == Tsung::Rails::Config
    end
  end

  describe "#recordings_dir" do
    it "calls Tsung::Rails::Config#recordings_dir" do
      Tsung::Rails::Config.should_receive(:recordings_dir).once
      Tsung::Rails.recordings_dir
    end

    it "returns a previously set value" do
      Tsung::Rails.recordings_dir = "/data/recordings"
      Tsung::Rails.recordings_dir.should == "/data/recordings"
    end
  end
end
