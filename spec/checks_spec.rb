require 'spec_helper'
require 'tsung/rails/checks'

describe Tsung::Rails::Checks do
  include Tsung::Rails::Checks

  [:tsung_version, :tsung_recorder_version, :tsung_stats_version].each do |method|
    describe "##{method}" do
      let(:version) { __send__(method) }

      it "is not null" do
        version.should_not be_nil
      end

      it "is not empty" do
        version.should_not be_empty
      end

      it "is 1.4.x" do
        version.should =~ /1\.4\.\d+/
      end
    end
  end

  it "runs checks without throwing exceptions" do
    check_tsung
    check_tsung_recorder
    check_tsung_stats
  end

end
