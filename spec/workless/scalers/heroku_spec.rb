require 'spec_helper'

describe Delayed::Workless::Scaler::Heroku do

  context 'with jobs' do

    before do
      Delayed::Workless::Scaler::Heroku.stub(:jobs).and_return(NumWorkers.new(10))
    end

    context 'without workers' do

      before do
        Delayed::Workless::Scaler::Heroku.stub(:workers).and_return(0)
      end

      it 'should set the workers to 1' do
        Delayed::Workless::Scaler::Heroku.client.should_receive(:put_workers).once.with(ENV['APP_NAME'], 1)
        Delayed::Workless::Scaler::Heroku.up
      end

    end

    context 'with workers' do

      before do
        Delayed::Workless::Scaler::Heroku.stub(:workers).and_return(NumWorkers.new(10))
      end

      it 'should not set anything' do
        Delayed::Workless::Scaler::Heroku.client.should_not_receive(:put_workers)
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
        Delayed::Workless::Scaler::Heroku.stub(:workers).and_return(0)
      end

      it 'should not set anything' do
        Delayed::Workless::Scaler::Heroku.client.should_not_receive(:put_workers)
        Delayed::Workless::Scaler::Heroku.down
      end

    end

    context 'with workers' do

      before do
        Delayed::Workless::Scaler::Heroku.stub(:workers).and_return(NumWorkers.new(10))
      end

      it 'should set the workers to 0' do
        Delayed::Workless::Scaler::Heroku.client.should_receive(:put_workers).once.with(ENV['APP_NAME'], 0)
        Delayed::Workless::Scaler::Heroku.down
      end

    end

  end

end
