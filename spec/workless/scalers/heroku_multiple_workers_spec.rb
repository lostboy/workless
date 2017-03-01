require 'spec_helper'

describe Delayed::Workless::Scaler::Heroku do
  describe 'up' do
    after(:each) do
      Delayed::Workless::Scaler::Heroku.up
    end

    context 'with no workers' do
      before(:each) do
        ENV['WORKLESS_WORKERS_RATIO'] = '25'
        ENV['WORKLESS_MAX_WORKERS'] = '10'
        ENV['WORKLESS_MIN_WORKERS'] = '0'
        Delayed::Workless::Scaler::Heroku.stub(:workers).and_return(0)
      end

      context 'with 10 max workers' do
        before(:each) do
          ENV['WORKLESS_MAX_WORKERS'] = '10'
        end

        context 'with a ratio of 25 jobs per worker' do
          before(:each) do
            ENV['WORKLESS_WORKERS_RATIO'] = '25'
          end

          it 'should set workers to 1 for 24 jobs' do
            if_there_are_jobs       24
            should_scale_workers_to 1
          end

          it 'should set workers to 1 for 25 jobs' do
            if_there_are_jobs       25
            should_scale_workers_to 1
          end

          it 'should set workers to 2 for 26 jobs' do
            if_there_are_jobs       26
            should_scale_workers_to 2
          end

          it 'should set workers to 3 for 51 jobs' do
            if_there_are_jobs       51
            should_scale_workers_to 3
          end

          it 'should set workers to 10 for 250 jobs' do
            if_there_are_jobs       250
            should_scale_workers_to 10
          end

          it 'should set workers to 10 for 5000 jobs' do
            if_there_are_jobs       5000
            should_scale_workers_to 10
          end
        end

        context 'with a ratio of 50 jobs per worker' do
          before(:each) do
            ENV['WORKLESS_WORKERS_RATIO'] = '50'
          end

          it 'should set workers to 1 for 50 jobs' do
            if_there_are_jobs       50
            should_scale_workers_to 1
          end

          it 'should set workers to 2 for 51 jobs' do
            if_there_are_jobs       51
            should_scale_workers_to 2
          end

          it 'should set workers to 10 for 500 jobs' do
            if_there_are_jobs       500
            should_scale_workers_to 10
          end

          it 'should set workers to 10 for 501 jobs' do
            if_there_are_jobs       501
            should_scale_workers_to 10
          end
        end
      end
    end

    context 'with workers' do
      before(:each) do
        Delayed::Workless::Scaler::Heroku.stub(:workers).and_return(1)
      end

      context 'with 10 max workers' do
        before(:each) do
          ENV['WORKLESS_MAX_WORKERS'] = '10'
        end

        context 'with 1 min workers' do
          before(:each) do
            ENV['WORKLESS_MIN_WORKERS'] = '2'
          end

          after(:all) do
            # Clear up for other specs
            ENV.delete('WORKLESS_MIN_WORKERS')
          end

          it 'should not fetch the number of workers for 1 jobs' do
            if_there_are_jobs 1
            Delayed::Workless::Scaler::Heroku.should_not_receive(:workers)
          end

          it 'should fetch the number of wokers exactly once for 1000 jobs' do
            if_there_are_jobs 1000
            Delayed::Workless::Scaler::Heroku.client.formation.stub(:update).and_return(true)
            Delayed::Workless::Scaler::Heroku.should_receive(:workers).exactly(:once)
          end
        end

        context 'with a ratio of 25 jobs per worker' do
          before(:each) do
            ENV['WORKLESS_WORKERS_RATIO'] = '25'
          end

          it 'should not set more workers for 25 jobs' do
            if_there_are_jobs 25
            should_not_scale_workers
          end

          it 'should set more workers for 26 jobs' do
            if_there_are_jobs       26
            should_scale_workers_to 2
          end
        end
      end
    end
  end

  describe 'down' do
    after(:each) do
      Delayed::Workless::Scaler::Heroku.down
    end

    before(:each) do
      Delayed::Workless::Scaler::Heroku.stub(:workers).and_return(1)
      ENV['WORKLESS_MAX_WORKERS']   = '10'
      ENV['WORKLESS_WORKERS_RATIO'] = '5'
    end

    context 'with 0 min workers' do
      before(:each) do
        ENV['WORKLESS_MIN_WORKERS'] = '0'
      end

      it 'should not scale down if there is a pending job' do
        if_there_are_jobs 1
        should_not_scale_workers
      end

      it 'should scale to 0 if there are no pending jobs' do
        if_there_are_jobs       0
        should_scale_workers_to 0
      end

      it 'should fetch the number of workers if there are no pending jobs' do
        if_there_are_jobs 0
        should_scale_workers_to 0
        Delayed::Workless::Scaler::Heroku.should_receive(:workers).exactly(:once)
      end
    end

    context 'with 1 min workers' do
      before(:each) do
        ENV['WORKLESS_MIN_WORKERS'] = '1'
      end

      it 'should not scale down if there is a pending job' do
        if_there_are_jobs 1
        should_not_scale_workers
      end

      it 'should not scale down even if there are no pending jobs' do
        if_there_are_jobs 0
        should_not_scale_workers
      end

      it 'should fetch the number of workers if there are no pending jobs' do
        if_there_are_jobs 0
        Delayed::Workless::Scaler::Heroku.should_receive(:workers).exactly(:once)
      end
      context 'with 5 running workers' do
        before(:each) do
          ENV['WORKLESS_WORKERS_RATIO'] = '25'
          ENV['WORKLESS_MAX_WORKERS'] = '10'
          Delayed::Workless::Scaler::Heroku.stub(:workers).and_return(10)
        end
        it 'should scale down to 1 worker when there are 2 jobs' do
          if_there_are_jobs 2
          should_scale_workers_to 1
        end

        it 'should scale down to 2 workers when there are 40 jobs' do
          if_there_are_jobs 40
          should_scale_workers_to 2
        end

        it 'should not scale workers when there are many jobs' do
          if_there_are_jobs 10_000
          should_not_scale_workers
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
end
