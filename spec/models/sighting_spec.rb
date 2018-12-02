require 'spec_helper'

describe Sighting do
  it "has a valid factory" do
    FactoryBot.create(:sightings).should be_valid
  end
  it "is invalid without a firstname"
  it "is invalid without a lastname"
  it "returns a contact's full name as a string"
end