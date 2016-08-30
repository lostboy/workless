require 'spec_helper'

describe Delayed::Workless::Scaler::HerokuCedar do
  context 'with no workers' do
    before(:each) do
      ENV['WORKLESS_WORKERS_RATIO'] = '25'
      ENV['WORKLESS_MAX_WORKERS'] = '10'
      ENV['WORKLESS_MIN_WORKERS'] = '0'
      Delayed::Workless::Scaler::HerokuCedar.stub(:workers).and_return(0)
    end
    context "with jobs" do
      context "run_at in the past" do
        it 'should set workers to 1 for 1 job' do
          if_there_are_jobs       1
          should_scale_workers_to 1

          Delayed::Workless::Scaler::HerokuCedar.up
        end
      end
      context "run_at in the future" do
        it 'should set workers to 0 for 1 job' do
          if_there_are_future_jobs       1
          should_not_scale_workers

          Delayed::Workless::Scaler::HerokuCedar.up
        end
      end
    end
  end

  private

  def if_there_are_jobs(num)
    Delayed::Workless::Scaler::HerokuCedar.should_receive(:jobs).at_least(1).times.and_return(NumWorkers.new(num))
  end

  def if_there_are_future_jobs(num)
    Delayed::Workless::Scaler::HerokuCedar.should_receive(:jobs).at_least(1).times.and_return(FutureJob.new)
  end

  def should_scale_workers_to(num)
    Delayed::Workless::Scaler::HerokuCedar.client.should_receive(:post_ps_scale).once.with(ENV['APP_NAME'], 'worker', num)
  end

  def should_not_scale_workers
    Delayed::Workless::Scaler::HerokuCedar.client.should_not_receive(:post_ps_scale)
  end
end
