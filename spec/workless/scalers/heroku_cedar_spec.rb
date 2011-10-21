require 'spec_helper'

describe Delayed::Workless::Scaler::HerokuCedar do

  context 'with jobs' do

    before do
      Delayed::Workless::Scaler::HerokuCedar.should_receive(:jobs).any_number_of_times.and_return(NumWorkers.new(10))
    end

    context 'without workers' do

      before do
        Delayed::Workless::Scaler::HerokuCedar.should_receive(:workers).and_return(0)
      end

      it 'should set the workers to 1' do
        Delayed::Workless::Scaler::HerokuCedar.client.should_receive(:ps_scale).once.with(ENV['APP_NAME'], :qty => 1, :type => 'worker')
        Delayed::Workless::Scaler::HerokuCedar.up
      end

    end

    context 'with workers' do

      before do
        Delayed::Workless::Scaler::HerokuCedar.should_receive(:workers).and_return(NumWorkers.new(10))
      end

      it 'should not set anything' do
        Delayed::Workless::Scaler::HerokuCedar.client.should_not_receive(:ps_scale)
        Delayed::Workless::Scaler::HerokuCedar.up
      end

    end

  end

  context 'with no jobs' do

    before do
      Delayed::Workless::Scaler::HerokuCedar.should_receive(:jobs).any_number_of_times.and_return(NumWorkers.new(0))
    end

    context 'without workers' do

      before do
        Delayed::Workless::Scaler::HerokuCedar.should_receive(:workers).and_return(0)
      end

      it 'should not set anything' do
        Delayed::Workless::Scaler::HerokuCedar.client.should_not_receive(:ps_scale)
        Delayed::Workless::Scaler::HerokuCedar.down
      end

    end

    context 'with workers' do

      before do
        Delayed::Workless::Scaler::HerokuCedar.should_receive(:workers).and_return(NumWorkers.new(10))
      end

      it 'should set the workers to 0' do
        Delayed::Workless::Scaler::HerokuCedar.client.should_receive(:ps_scale).once.with(ENV['APP_NAME'], :qty => 0, :type => 'worker')
        Delayed::Workless::Scaler::HerokuCedar.down
      end

    end

  end

end
