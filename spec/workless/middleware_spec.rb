require 'spec_helper'
require 'rack/mock'
require 'rack/test'
require 'delayed_job'
# Load the middleware
require_relative '../../lib/workless/middleware/workless_checker.rb'

describe WorklessChecker do
  let(:app) { lambda {|env| [200, {'Content-Type' => 'text/plain'}, ['OK']]} }
  subject { WorklessChecker.new(app) }

  context "when a GET request comes in" do
    let(:request) { Rack::MockRequest.new(subject) }
    before(:each) do
      request.get("/some/path", 'CONTENT_TYPE' => 'text/plain')
    end

    context "when there are no jobs" do
      pending 'Figure out how to test middleware'
      before do
        # Delayed::Job.scaler.stub(:jobs).and_return(NumWorkers.new(0))
      end
      it 'should not scale up' do
        # Delayed::Job.scaler.should_not_receive(:up)
      end
    end
  end
end