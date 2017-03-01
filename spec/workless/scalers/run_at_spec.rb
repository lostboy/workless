require 'spec_helper'

describe Delayed::Workless::Scaler::Heroku do
  context 'with no workers' do
    before(:each) do
      ENV['WORKLESS_WORKERS_RATIO'] = '25'
      ENV['WORKLESS_MAX_WORKERS'] = '10'
      ENV['WORKLESS_MIN_WORKERS'] = '0'
      Delayed::Workless::Scaler::Heroku.stub(:workers).and_return(0)
    end
    context 'with jobs' do
      context 'run_at in the past' do
        it 'should set workers to 1 for 1 job' do
          if_there_are_jobs       1
          should_scale_workers_to 1

          Delayed::Workless::Scaler::Heroku.up
        end
      end
      context 'run_at in the future' do
        it 'should set workers to 0 for 1 job' do
          if_there_are_future_jobs 1
          should_not_scale_workers

          Delayed::Workless::Scaler::Heroku.up
        end
      end
    end
  end

  private

  def if_there_are_jobs(num)
    Delayed::Workless::Scaler::Heroku.should_receive(:jobs).at_least(1).times.and_return(NumWorkers.new(num))
  end

  def should_scale_workers_to(num)
    updates = { "quantity": num }
    Delayed::Workless::Scaler::Heroku.client.formation.should_receive(:update).once.with(ENV['APP_NAME'], 'worker', updates)
  end

  def should_not_scale_workers
    Delayed::Workless::Scaler::Heroku.client.formation.should_not_receive(:update)
  end

  def if_there_are_future_jobs(_num)
    Delayed::Workless::Scaler::Heroku.should_receive(:jobs).at_least(1).times.and_return(FutureJob.new)
  end
end
