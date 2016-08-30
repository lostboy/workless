require 'spec_helper'
describe Delayed::Workless::Scaler::Local do
  context 'with jobs' do
    let(:fake_class) { Class.new }
    
    before do
      stub_const("Rails", fake_class)
      Rails.stub(:root).and_return('/tmp')

      Delayed::Workless::Scaler::Local.stub(:jobs).and_return(NumWorkers.new(10))
    end
      context 'without workers' do
        before do
          Delayed::Workless::Scaler::Local.stub(:workers).and_return(0)
        end

        it 'should set the workers to 1' do
          Delayed::Workless::Scaler::Local.should_receive(:workers).once
          Delayed::Workless::Scaler::Local.up
        end
      end

      context 'with workers' do
        before do
          Delayed::Workless::Scaler::Local.stub(:workers).and_return(NumWorkers.new(10))
        end

        it 'should not set anything' do
          Delayed::Workless::Scaler::Local.should_receive(:workers).once
          Delayed::Workless::Scaler::Local.up
        end
      end
  end
end