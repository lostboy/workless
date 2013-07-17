require 'spec_helper'

describe Delayed::Workless::Scaler::HerokuCedar do
  before(:each) do
    ENV['WORKLESS_MAX_WORKERS'] = ENV['WORKLESS_MIN_WORKERS'] = ENV['WORKLESS_WORKERS_RATIO'] = nil
  end

  context 'with jobs' do

    before do
      Delayed::Workless::Scaler::HerokuCedar.stub(:jobs).and_return(NumWorkers.new(10))
    end

    context 'without workers' do

      before do
        Delayed::Workless::Scaler::HerokuCedar.stub(:workers).and_return(0)
      end

      it 'should set the workers to 1' do
        Delayed::Workless::Scaler::HerokuCedar.client.should_receive(:post_ps_scale).once.with(ENV['APP_NAME'], 'worker', 1)
        Delayed::Workless::Scaler::HerokuCedar.up
      end

    end

    context 'with workers' do

      before do
        Delayed::Workless::Scaler::HerokuCedar.stub(:workers).and_return(10)
      end

      it 'should not set anything' do
        Delayed::Workless::Scaler::HerokuCedar.client.should_not_receive(:post_ps_scale)
        Delayed::Workless::Scaler::HerokuCedar.up
      end

    end

  end

  context 'with no jobs' do

    before do
      Delayed::Workless::Scaler::HerokuCedar.stub(:jobs).and_return(NumWorkers.new(0))
    end

    context 'without workers' do

      before do
        Delayed::Workless::Scaler::HerokuCedar.should_receive(:workers).and_return(0)
      end

      it 'should not set anything' do
        Delayed::Workless::Scaler::HerokuCedar.client.should_not_receive(:post_ps_scale)
        Delayed::Workless::Scaler::HerokuCedar.down
      end

    end

    context 'with workers' do

      before do
        Delayed::Workless::Scaler::HerokuCedar.stub(:workers).and_return(NumWorkers.new(10))
      end

      it 'should set the workers to 0' do
        Delayed::Workless::Scaler::HerokuCedar.client.should_receive(:post_ps_scale).once.with(ENV['APP_NAME'], 'worker', 0)
        Delayed::Workless::Scaler::HerokuCedar.down
      end

    end

  end

end
