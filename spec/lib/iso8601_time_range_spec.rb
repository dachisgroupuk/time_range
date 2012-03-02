require 'spec_helper'

describe Iso8601TimeRange do
  context "when not initialized with a TimeRange" do
    it "should raise error" do
      expect{
        Iso8601TimeRange.new([1, 2])
      }.to raise_error ArgumentError
    end
  end
  
  context "when initialized with a TimeRange" do
    let(:time_range) { TimeRange.today }
    subject { Iso8601TimeRange.new(time_range) }
    
    it { subject.start.should == time_range.start.utc.iso8601 }
    it { subject.finish.should == time_range.finish.utc.iso8601 }
  end
end
