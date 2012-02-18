[![Build Status](https://secure.travis-ci.org/lostboy/workless.png?branch=master)](http://travis-ci.org/lostboy/workless)

# Workless

This is an addon for delayed_job (> 2.0.0) http://github.com/collectiveidea/delayed_job
It is designed to be used when you're using Heroku as a host and have the need to do background work with delayed job but you don't want to leave the workers running all the time as it costs money.

You basically add the gem to your project and the rest is taken care of for you given a few CONFIG vars set on Heroku.

There are already a few of these out there, notably @mtravers' cheepnis http://github.com/mtravers/cheepnis and the autoscale branch of delayed_job by @pedro http://github.com/pedro/delayed_job/tree/autoscaling

Workless takes ideas from both and is helping me understand gem and plugin development. Prior to version 1.0.0 it was originally built for rails 3 on the delayed_job 2.1.0.pre2 but since 1.0.0 is compatible with rails 2.3.x, 3.0.x, 3.1.x and 3.2.x

## Installation

Add the workless gem and the delayed_job gem to your project Gemfile and update your bundle. Its is recommended to specify the gem version for delayed_job especially if you are using rails 2.3.x which doesn't work with the latest delayed_job

<pre>
gem "workless"
</pre>

Add your Heroku username / password as config vars to your Heroku instance, the same one you log in to Heroku with

<pre>
heroku config:add HEROKU_USER=yourusername HEROKU_PASSWORD=yourpassword
</pre>

And for cedar apps add the app name

<pre>
heroku config:add APP_NAME=yourherokuappname
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
Delayed::Job.scaler = :heroku_cedar
Delayed::Job.scaler = :local
</pre>

The local scaler uses @adamwiggins rush library http://github.com/adamwiggins/rush to start and stop workers on a local machine

The heroku scaler works on the Aspen and Bamboo stacks while the heroku_cedar scaler only works on the new Cedar stack.

## Note on Patches/Pull Requests
 
* Please fork the project, as you can see there are no tests and at present I don't know how to go about adding them so any advice would be welcome.
* Make your feature addition or bug fix.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request.

## Copyright

Copyright (c) 2010 lostboy. See LICENSE for details.
