require 'spec_helper'

describe Delayed::Workless::Scaler::HerokuCedar do

  describe 'up' do
    after(:each) do
      Delayed::Workless::Scaler::HerokuCedar.up
    end

    context 'with no workers' do
      before(:each) do
        Delayed::Workless::Scaler::HerokuCedar.stub(:workers).and_return(0)
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
        Delayed::Workless::Scaler::HerokuCedar.stub(:workers).and_return(1)
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
            #Clear up for other specs
            ENV.delete('WORKLESS_MIN_WORKERS')
          end

          it "should not fetch the number of workers for 1 jobs" do
            if_there_are_jobs 1
            Delayed::Workless::Scaler::HerokuCedar.should_not_receive(:workers)
          end

          it "should fetch the number of wokers exactly once for 1000 jobs" do
            if_there_are_jobs 1000
            Delayed::Workless::Scaler::HerokuCedar.client.stub(:post_ps_scale).and_return(true)
            Delayed::Workless::Scaler::HerokuCedar.should_receive(:workers).exactly(:once)
          end
        end

        context 'with a ratio of 25 jobs per worker' do
          before(:each) do
            ENV['WORKLESS_WORKERS_RATIO'] = '25'
          end

          it 'should not set more workers for 25 jobs' do
            if_there_are_jobs       25
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
      Delayed::Workless::Scaler::HerokuCedar.down
    end

    before(:each) do
      Delayed::Workless::Scaler::HerokuCedar.stub(:workers).and_return(1)
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

      it "should not fetch the number of workers if there is a pending job" do
        if_there_are_jobs 1
        Delayed::Workless::Scaler::HerokuCedar.should_not_receive(:workers)
      end

      it 'should scale to 0 if there are no pending jobs' do
        if_there_are_jobs       0
        should_scale_workers_to 0
      end

      it "should fetch the number of workers if there are no pending jobs" do
        if_there_are_jobs 0
        should_scale_workers_to 0
        Delayed::Workless::Scaler::HerokuCedar.should_receive(:workers).exactly(:once)
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

      it "should not fetch the number of workers if there is a pending job" do
        if_there_are_jobs 1
        Delayed::Workless::Scaler::HerokuCedar.should_not_receive(:workers)
      end

      it 'should not scale down even if there are no pending jobs' do
        if_there_are_jobs 0
        should_not_scale_workers
      end

      it "should fetch the number of workers if there are no pending jobs" do
        if_there_are_jobs 0
        Delayed::Workless::Scaler::HerokuCedar.should_receive(:workers).exactly(:once)
      end
    end
  end

  private

  def if_there_are_jobs(num)
    Delayed::Workless::Scaler::HerokuCedar.should_receive(:jobs).any_number_of_times.and_return(NumWorkers.new(num))
  end

  def should_scale_workers_to(num)
    Delayed::Workless::Scaler::HerokuCedar.client.should_receive(:post_ps_scale).once.with(ENV['APP_NAME'], 'worker', num)
  end

  def should_not_scale_workers
    Delayed::Workless::Scaler::HerokuCedar.client.should_not_receive(:post_ps_scale)
  end
end
