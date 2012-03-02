require 'spec_helper'

describe TimeRange::Iso8601 do
  context "when not initialized with a TimeRange" do
    it "should raise error" do
      expect{
        TimeRange::Iso8601.new([1, 2])
      }.to raise_error ArgumentError
    end
  end
  
  context "when initialized with a TimeRange" do
    let(:time_range) { TimeRange.today }
    subject { TimeRange::Iso8601.new(time_range) }
    
    it { subject.start.should == time_range.start.utc.iso8601 }
    it { subject.finish.should == time_range.finish.utc.iso8601 }
  end
end
