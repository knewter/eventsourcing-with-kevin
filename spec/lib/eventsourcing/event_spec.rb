require_relative '../../spec_helper'

describe Event do
  before do
    @event = Event.new
  end

  it "has occurred_at attribute" do
    @event.must_respond_to :occurred_at=
    @event.must_respond_to :occurred_at
  end

  it "has recorded_at attribute" do
    @event.must_respond_to :recorded_at=
    @event.must_respond_to :recorded_at
  end

  it "defaults to current time on initialization" do
    @event.occurred_at.wont_be_nil
  end
end
