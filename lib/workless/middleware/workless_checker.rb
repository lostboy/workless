class WorklessChecker
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)
    return [status, headers, response] if file?(headers) || empty?(response)

    Delayed::Job.scaler.up unless Delayed::Job.scaler.jobs.empty?

    [status, headers, response]
  end

  # fix issue if response's body is a Proc
  def empty?(response)
    # response may be ["Not Found"], ["Move Permanently"], etc.
    (response.is_a?(Array) && response.size <= 1) ||
      !response.respond_to?(:body) ||
      !response.body.respond_to?(:empty?) ||
      response.body.empty?
  end

  # if send file?
  def file?(headers)
    headers['Content-Transfer-Encoding'] == 'binary'
  end
end
