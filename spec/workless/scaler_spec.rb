require 'spec_helper'

describe Delayed::Workless::Scaler do

  context 'on heroku' do

    before do
      Delayed::Job::Mock.send(:instance_variable_set, :@scaler, nil)
      ENV['HEROKU_UPID'] = 'something or other'
    end

    it 'should be the heroku scaler' do
      Delayed::Job::Mock.scaler.should == Delayed::Workless::Scaler::Heroku
    end

  end

  context 'locally' do

    before do
      Delayed::Job::Mock.send(:instance_variable_set, :@scaler, nil)
      ENV.delete('HEROKU_UPID')
    end

    it 'should be the local scaler' do
      Delayed::Job::Mock.scaler.should == Delayed::Workless::Scaler::Local
    end

  end

  context 'setting a scaler' do

    context 'with a known scaler' do

      before do
        Delayed::Job::Mock.scaler = :heroku_logarithmic
      end

      it 'should be properly assigned' do
        Delayed::Job::Mock.scaler.should == Delayed::Workless::Scaler::HerokuLogarithmic
      end

    end

    context 'with a non-workless defined scaler' do

      before do
        class Delayed::Workless::Scaler::Something < Delayed::Workless::Scaler::Base
          def self.up
          end
          def self.down
          end
        end

        Delayed::Job::Mock.scaler = :something
      end

      it 'should be properly assigned' do
        Delayed::Job::Mock.scaler.should == Delayed::Workless::Scaler::Something
      end

    end

  end

end
