class WorklessChecker
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)
    return [status, headers, response] if file?(headers) || empty?(response)

    Delayed::Job.scaler.up if Delayed::Job.scaler.jobs.size > 0
    response_body = nil
    if status == 200 && !response.body.frozen? && html_request?(headers, response)
      response_body = response.body << "\n<!-- workless jobs: #{Delayed::Job.scaler.jobs.size} -->"
      headers['Content-Length'] = response_body.bytesize.to_s
    end

    [status, headers, response_body ? [response_body] : response]
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

  def html_request?(headers, response)
    headers['Content-Type'] && headers['Content-Type'].include?('text/html') && response.body.include?('<html')
  end
end
