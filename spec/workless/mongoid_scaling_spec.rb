require 'spec_helper'

describe Delayed::Mongoid::Job do
  context 'with mongoid scaler' do
    before(:each) do
      ENV['WORKLESS_WORKERS_RATIO'] = '25'
      Delayed::Mongoid::Job::Mock.scaler = :heroku_cedar
    end
    context 'with no workers' do
      before(:each) do
        Delayed::Mongoid::Job::Mock.scaler.should_receive(:workers).and_return(0)
      end
      it "should scale up" do
        if_there_are_jobs 1
        should_scale_workers_to 1

        Delayed::Mongoid::Job::Mock.scaler.up
      end
      it "should scale up" do
        if_there_are_jobs 5
        should_scale_workers_to 1

        Delayed::Mongoid::Job::Mock.scaler.up
      end
      it 'should not scale' do
        if_there_are_jobs 0
        should_not_scale_workers
        Delayed::Workless::Scaler::HerokuCedar.down
      end
    end
    context 'with 1 worker' do
      before(:each) do
        Delayed::Mongoid::Job::Mock.scaler.stub(:workers).and_return(1)
      end
      it "should scale down to none" do
        if_there_are_jobs 1
        should_not_scale_workers

        Delayed::Mongoid::Job::Mock.scaler.up
      end
      it "should scale down to 1" do
        if_there_are_jobs 1
        should_not_scale_workers

        Delayed::Mongoid::Job::Mock.scaler.down
      end
    end

    context 'with 5 workers' do
      before(:each) do
        Delayed::Mongoid::Job::Mock.scaler.stub(:workers).and_return(5)
      end
      it "should scale down to none" do
        if_there_are_jobs 0
        should_scale_workers_to 0

        Delayed::Mongoid::Job::Mock.scaler.down
      end
      pending "This will be a new feature" do
        it "should scale down to 1" do
          if_there_are_jobs 1
          should_scale_workers_to 1

          Delayed::Mongoid::Job::Mock.scaler.down
        end
      end
    end
  end

  private

    def if_there_are_jobs(num)
      Delayed::Mongoid::Job::Mock.scaler.stub(:jobs).and_return(NumWorkers.new(num))
    end

    def should_scale_workers_to(num)
      Delayed::Mongoid::Job::Mock.scaler.client.should_receive(:post_ps_scale).once.with(ENV['APP_NAME'], 'worker', num)
    end

    def should_not_scale_workers
      Delayed::Mongoid::Job::Mock.scaler.client.should_not_receive(:post_ps_scale)
    end

end
