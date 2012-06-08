require_relative '../../spec_helper'

describe Event do
  before do
    @event = Event.new
  end

  it "has occurred_at attribute" do
    assert_respond_to @event, :occurred_at=
    assert_respond_to @event, :occurred_at
  end
  
  it "has recorded_at attribute" do
    assert_respond_to @event, :recorded_at=
    assert_respond_to @event, :recorded_at
  end
  
  it "defaults to current time on initialization" do
    wont_be_nil @event.occurred_at
  end
end