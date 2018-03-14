[![Build Status](https://secure.travis-ci.org/lostboy/workless.png?branch=master)](http://travis-ci.org/lostboy/workless)
[![Gem Version](https://badge.fury.io/rb/workless.png)](http://badge.fury.io/rb/workless)
[![Test Coverage](https://coveralls.io/repos/lostboy/workless/badge.png?branch=master)](https://coveralls.io/r/lostboy/workless)

# Workless

This is an addon for delayed_job (> 2.0.0) http://github.com/collectiveidea/delayed_job
It is designed to be used when you're using Heroku as a host and have the need to do background work with delayed job but you don't want to leave the workers running all the time as it costs money.

## Installation

Add the workless gem and the delayed_job gem to your project Gemfile and update your bundle. Its is recommended to specify the gem version for delayed_job

<pre>
gem "delayed_job_active_record"
gem 'workless', git: 'https://github.com/patricklindsay/workless.git', tag: 'v3.0.0'
</pre>

If you don't specify delayed_job in your Gemfile workless will bring it in, most likely the latest version (4.1.2)

Add your Heroku app name & [API key](https://devcenter.heroku.com/articles/authentication) as config vars to your Heroku instance.

<pre>
heroku config:add WORKLESS_API_KEY=yourapikey APP_NAME=yourherokuappname
</pre>

Lastly, add the below callback to your `ApplicationController`.

<pre>
before_action :work_off_delayed_jobs
</pre>

You're good to go! Whenever a job is created Workless will automatically provision a workers and turn them off when all jobs are complete.


## How does Workless work?

Workless activates workers in two ways;
1. When a job is created a callback starts a worker so long as the job is to be ran straight away or before the next check (defined by `Workless.work_off_timeout`)
2. Upon each controller request Workless checks if workers need to be activated. This picks up scheduled or previously failed jobs.


## Configuration

Configure the timeout Workless uses between checking if workers are required (default is 1 minute);

<pre>
Workless.work_off_timeout = 30.seconds
</pre>

Workless can be disabled by using the null scaler that will ignore the workers requests to scale up and down. In an environment file add this in the config block:

<pre>
config.after_initialize do
  Delayed::Job.scaler = :null
end
</pre>

There are three other scalers included. Note that if you are running on the Aspen or Bamboo stacks on Heroku and you don't explicitly specify the scaler, the heroku scaler will be used automatically.

<pre>
Delayed::Job.scaler = :heroku
Delayed::Job.scaler = :heroku
Delayed::Job.scaler = :local
</pre>

The local scaler uses @adamwiggins rush library http://github.com/adamwiggins/rush to start and stop workers on a local machine. The local scaler also relies on script/delayed_job (which in turn requires the daemon gem). If you have been using foreman to run your workers, go back and see the delayed_job [setup instructions](https://github.com/collectiveidea/delayed_job/blob/master/README.md).

The heroku scaler works on the Aspen and Bamboo stacks while the heroku_cedar scaler only works on the new Cedar stack.

## Scaling to multiple workers

As an experimental feature for the Cedar stack, Workless can scale to more than 1 worker based on the current work load. You just need to define these config variables on your app, setting the values you want:

<pre>
heroku config:add WORKLESS_MAX_WORKERS=10
heroku config:add WORKLESS_MIN_WORKERS=0
heroku config:add WORKLESS_WORKERS_RATIO=50
</pre>

In this example, it will scale up to a maximum of 10 workers, firing up 1 worker for every 50 jobs on the queue. The minimum will be 0 workers, but you could set it to a higher value if you want.

## Note on Patches/Pull Requests

* Please fork the project.
* Make your feature addition or bug fix.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request.

## Copyright

Copyright (c) 2010 lostboy.
Copyright (c) 2016 davidakachaos.
Copyright (c) 2017 lostboy && davidakachaos.

See LICENSE for details.
