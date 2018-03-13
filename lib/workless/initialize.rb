# frozen_string_literal: true

Delayed::Backend::ActiveRecord::Job.send(:include, Delayed::Workless::Scaler) if defined?(Delayed::Backend::ActiveRecord::Job)
Delayed::Backend::Mongoid::Job.send(:include, Delayed::Workless::Scaler) if defined?(Delayed::Backend::Mongoid::Job)
Delayed::Backend::MongoMapper::Job.send(:include, Delayed::Workless::Scaler) if defined?(Delayed::Backend::MongoMapper::Job)
Delayed::Backend::Sequel::Job.send(:include, Delayed::Workless::Scaler) if defined?(Delayed::Backend::Sequel::Job)

