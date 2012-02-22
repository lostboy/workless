[![Build Status](https://secure.travis-ci.org/lostboy/workless.png?branch=master)](http://travis-ci.org/lostboy/workless)

# Workless

This is an addon for delayed_job (> 2.0.0) http://github.com/collectiveidea/delayed_job
It is designed to be used when you're using Heroku as a host and have the need to do background work with delayed job but you don't want to leave the workers running all the time as it costs money.

By adding the gem to your project and configuring our Heroku app with some config variables workless should do the rest.

## Update

Version 1.0.0 has been released, this brings compatibility with delayed_job 3 and compatibility with Rails 2.3.x and up.

## Compatibility

Workless should work correctly with Rubies 1.8.7, ree, 1.9.2 and 1.9.3. It is compatible with Delayed Job since version 2.0.7 up to the latest version 3.0.1, the table below shows tested compatibility with ruby, rails and delayed_job

Ruby | Rails  | Delayed Job
---------- | ------ | -----
1.8.7-ree  | 2.1.14 | 2.0.7
1.9.2      | 3.2    | 2.1.4
1.9.2      | 3.2    | 3.0.1

## Installation

Add the workless gem and the delayed_job gem to your project Gemfile and update your bundle. Its is recommended to specify the gem version for delayed_job especially if you are using rails 2.3.x which doesn't work with the latest delayed_job

### For rails 2.3.x the latest compatible delayed_job is 2.0.7

<pre>
gem "delayed_job", "2.0.7"
gem "workless", "~> 1.0.1"
</pre>

### For rails 3.x with delayed_job 2.1.x

<pre>
gem "delayed_job", "~> 2.1.4"
gem "workless", "~> 1.0.1"
</pre>

### For rails 3.x with latest delayed_job 3.x using active record

<pre>
gem "delayed_job_active_record"
gem "workless", "~> 1.0.1"
</pre>

If you don't specify delayed_job in your Gemfile workless will bring it in, most likly the latest version (3.0.1)

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
