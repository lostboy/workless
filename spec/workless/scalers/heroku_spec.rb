require 'spec_helper'

describe Delayed::Workless::Scaler::Heroku do
  before(:each) do
    ENV['WORKLESS_MAX_WORKERS'] = ENV['WORKLESS_MIN_WORKERS'] = ENV['WORKLESS_WORKERS_RATIO'] = nil
  end

  context 'with jobs' do
    before do
      Delayed::Workless::Scaler::Heroku.stub(:jobs).and_return(NumWorkers.new(10))
    end

    context 'without workers' do
      before do
        Delayed::Workless::Scaler::Heroku.stub(:workers).and_return(0)
      end

      it 'should set the workers to 1' do
        updates = { "quantity": 1 }
        Delayed::Workless::Scaler::Heroku.client.formation.should_receive(:update).once.with(ENV['APP_NAME'], 'worker', updates)
        Delayed::Workless::Scaler::Heroku.up
      end
    end

    context 'with workers' do
      before do
        Delayed::Workless::Scaler::Heroku.stub(:workers).and_return(10)
      end

      it 'should not set anything' do
        Delayed::Workless::Scaler::Heroku.client.formation.should_not_receive(:update)
        Delayed::Workless::Scaler::Heroku.up
      end
    end
  end

  context 'with no jobs' do
    before do
      Delayed::Workless::Scaler::Heroku.stub(:jobs).and_return(NumWorkers.new(0))
    end

    context 'without workers' do
      before do
        Delayed::Workless::Scaler::Heroku.should_receive(:workers).and_return(0)
      end

      it 'should not set anything' do
        Delayed::Workless::Scaler::Heroku.client.formation.should_not_receive(:update)
        Delayed::Workless::Scaler::Heroku.down
      end
    end

    context 'with workers' do
      before do
        Delayed::Workless::Scaler::Heroku.stub(:workers).and_return(NumWorkers.new(10))
      end

      it 'should set the workers to 0' do
        updates = { "quantity": 0 }
        Delayed::Workless::Scaler::Heroku.client.formation.should_receive(:update).once.with(ENV['APP_NAME'], 'worker', updates)
        Delayed::Workless::Scaler::Heroku.down
      end
    end
  end
end
