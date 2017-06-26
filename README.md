[![Build Status](https://secure.travis-ci.org/davidakachaos/workless_revived.png?branch=master)](http://travis-ci.org/davidakachaos/workless_revived)
[![Gem Version](https://badge.fury.io/rb/workless_revived.png)](http://badge.fury.io/rb/workless_revived)
[![Test Coverage](https://coveralls.io/repos/davidakachaos/workless_revived/badge.png?branch=master)](https://coveralls.io/r/davidakachaos/workless_revived)

# Workless Revived

This gem was originally created by [lostboy](https://github.com/lostboy). Since he became inactive, I've decided to revive this project under a new(ish) name.

This is an addon for delayed_job (> 2.0.0) http://github.com/collectiveidea/delayed_job
It is designed to be used when you're using Heroku as a host and have the need to do background work with delayed job but you don't want to leave the workers running all the time as it costs money.

By adding the gem to your project and configuring our Heroku app with some config variables workless should do the rest.

:warning: **[The Legacy API will be sunset on April 15th, 2017](https://devcenter.heroku.com/changelog-items/862)** :warning:
Please upgrade to version 2.0.0 as soon as you can. Version 2.0.0 is released on March 1st, 2017.

## Heroku Stack Heroku-16 update
Version 2.1.0 changed the config for setting the Heroku API key. This will now reside in WORKLESS_API_KEY. Please change this key in your Heroku setup when upgrading this gem!

## Updates

* Version 2.1.0 CHANGE! In order to be compatible with the latest Heroku Stack (see [#11](https://github.com/davidakachaos/workless_revived/issues/11) by @unmultimedio  ) I have changed the name for the HEROKU_API_KEY variable to WORKLESS_API_KEY
* Version 2.0.0 Updated to use latest version of the Heroku API. Drops support for old style Heroku
* Version 1.3.0 DROPS SUPPORT FOR OLDER RUBY AND RAILS VERSIONS!
* Version 1.2.5 Added middleware to check on delayed jobs, fixed Rails 5 support
* Version 1.2.4 drops support for older versions!
* Version 1.2.3 replaces multiple commit callback with two callbacks for compatibility by @lostboy
* Version 1.2.2 includes after_commit fix by @collectiveip
* Version 1.2.1 includes support for Rails 4 & DJ 4 by @florentmorin
* Version 1.2.0 includes new support for Sequel by @davidakachaos
* Version 1.1.3 includes changes by @radanskoric to reduce number of heroku api calls
* Version 1.1.2 includes a change by @davidakachaos to scale workers using after_commit
* Version 1.1.1 includes a fix from @filiptepper and @fixr to correctly scale workers
* Version 1.1.0 has been released, this adds support for scaling using multiple workers thanks to @jaimeiniesta and @davidakachaos.
* Version 1.0.0 has been released, this brings compatibility with delayed_job 3 and compatibility with Rails 2.3.x and up.

## Compatibility

Workless should work correctly with Rubies 2.0.0 and up. It is compatible with Delayed Job since version 2.0.7 up to the latest version 4.1.2, the table below shows tested compatibility with ruby, rails and delayed_job

Ruby | Rails  | Delayed Job
---------- | ------ | -----
2.2.5      | 4.2    | 2.1.4
2.3.1      | 5.0    | 4.1.2
2.4.1      | 5.1    | 4.1.3

## Installation

Add the workless gem and the delayed_job gem to your project Gemfile and update your bundle. Its is recommended to specify the gem version for delayed_job

### For rails 4.x with latest delayed_job 3.x using active record

<pre>
gem "delayed_job_active_record"
gem "workless_revived", "~> 1.2.4"
</pre>

### For rails 5.x with latest delayed_job 3.x using active record

<pre>
gem "delayed_job_active_record"
gem "workless_revived", "~> 1.2.4"
</pre>


If you don't specify delayed_job in your Gemfile workless will bring it in, most likely the latest version (4.1.2)

Add your Heroku app name / [API key](https://devcenter.heroku.com/articles/authentication) as config vars to your Heroku instance.

<pre>
heroku config:add WORKLESS_API_KEY=yourapikey APP_NAME=yourherokuappname
</pre>

## Failing Jobs

In the case of failed jobs Workless will only shut down the dj worker if all attempts have been tried. By default Delayed Job will try 25 times to process a job with ever increasing time delays between each unsucessful attempt. Because of this Workless configures Delayed Job to try failed jobs only 3 times to reduce the amount of time a worker can be running while trying to process them.

## Configuration

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

## How does Workless work?

- `Delayed::Workless::Scaler` is mixed into the `Delayed::Job` class, which adds a bunch of callbacks to it.
- When a job is created on the database, a `create` callback starts a worker.
- The worker runs the job, which removes it from the database.
- A `destroy` callback stops the worker.

## Note on Patches/Pull Requests

* Please fork the project.
* Make your feature addition or bug fix.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request.

## Copyright

Copyright (c) 2010 lostboy.
Copyright (c) 2016 davidakachaos.

See LICENSE for details.
