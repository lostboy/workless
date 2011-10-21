require 'spec_helper'

describe Delayed::Workless::Scaler::HerokuLogarithmic10 do

  context 'with 1 job' do

    before do
      Delayed::Workless::Scaler::HerokuLogarithmic10.should_receive(:jobs).any_number_of_times.and_return(NumWorkers.new(1))
    end

    context 'without workers' do

      before do
        Delayed::Workless::Scaler::HerokuLogarithmic10.should_receive(:workers).and_return(0)
      end

      it 'should set the workers to 1' do
        Delayed::Workless::Scaler::HerokuLogarithmic10.client.should_receive(:set_workers).once.with(ENV['APP_NAME'], 1)
        Delayed::Workless::Scaler::HerokuLogarithmic10.up
      end

    end

    context 'with workers' do

      before do
        Delayed::Workless::Scaler::HerokuLogarithmic10.should_receive(:workers).any_number_of_times.and_return(1)
      end

      it 'should not set anything' do
        Delayed::Workless::Scaler::HerokuLogarithmic10.client.should_not_receive(:set_workers)
        Delayed::Workless::Scaler::HerokuLogarithmic10.up
      end

    end

  end

  context 'with 10 jobs' do

    before do
      Delayed::Workless::Scaler::HerokuLogarithmic10.should_receive(:jobs).any_number_of_times.and_return(NumWorkers.new(10))
    end

    context 'without workers' do

      before do
        Delayed::Workless::Scaler::HerokuLogarithmic10.should_receive(:workers).and_return(0)
      end

      it 'should set the workers to 1' do
        Delayed::Workless::Scaler::HerokuLogarithmic10.client.should_receive(:set_workers).once.with(ENV['APP_NAME'], 1)
        Delayed::Workless::Scaler::HerokuLogarithmic10.up
      end

    end

    context 'with 1 worker' do

      before do
        Delayed::Workless::Scaler::HerokuLogarithmic10.should_receive(:workers).and_return(1)
      end

      it 'should not set anything' do
        Delayed::Workless::Scaler::HerokuLogarithmic10.client.should_not_receive(:set_workers)
        Delayed::Workless::Scaler::HerokuLogarithmic10.up
      end

    end

  end

  context 'with 100 jobs' do

    before do
      Delayed::Workless::Scaler::HerokuLogarithmic10.should_receive(:jobs).any_number_of_times.and_return(NumWorkers.new(100))
    end

    context 'without workers' do

      before do
        Delayed::Workless::Scaler::HerokuLogarithmic10.should_receive(:workers).and_return(0)
      end

      it 'should set the workers to 2' do
        Delayed::Workless::Scaler::HerokuLogarithmic10.client.should_receive(:set_workers).once.with(ENV['APP_NAME'], 2)
        Delayed::Workless::Scaler::HerokuLogarithmic10.up
      end

    end

    context 'with 1 worker' do

      before do
        Delayed::Workless::Scaler::HerokuLogarithmic10.should_receive(:workers).and_return(1)
      end

      it 'should set the workers to 2' do
        Delayed::Workless::Scaler::HerokuLogarithmic10.client.should_receive(:set_workers).once.with(ENV['APP_NAME'], 2)
        Delayed::Workless::Scaler::HerokuLogarithmic10.up
      end

    end

  end

  context 'with no jobs' do

    before do
      Delayed::Workless::Scaler::HerokuLogarithmic10.should_receive(:jobs).any_number_of_times.and_return(NumWorkers.new(0))
    end

    context 'without workers' do

      before do
        Delayed::Workless::Scaler::HerokuLogarithmic10.should_receive(:workers).and_return(0)
      end

      it 'should not set anything' do
        Delayed::Workless::Scaler::HerokuLogarithmic10.client.should_not_receive(:set_workers)
        Delayed::Workless::Scaler::HerokuLogarithmic10.down
      end

    end

    context 'with workers' do

      before do
        Delayed::Workless::Scaler::HerokuLogarithmic10.should_receive(:workers).and_return(10)
      end

      it 'should set the workers to 0' do
        Delayed::Workless::Scaler::HerokuLogarithmic10.client.should_receive(:set_workers).once.with(ENV['APP_NAME'], 0)
        Delayed::Workless::Scaler::HerokuLogarithmic10.down
      end

    end

  end

end
