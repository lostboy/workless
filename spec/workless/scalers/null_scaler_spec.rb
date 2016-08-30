require 'spec_helper'
describe Delayed::Workless::Scaler::Null do
  it "should respond like a scaler" do
    Delayed::Workless::Scaler::Null.should respond_to(:up)
    Delayed::Workless::Scaler::Null.should respond_to(:down)
  end
end