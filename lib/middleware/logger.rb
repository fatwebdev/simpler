require 'logger'

class SimplerLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)

    file = File.open(Simpler.root.join('log/app.log'), 'a+')
    logger = Logger.new(file)
    logger.info log_message(env, status, headers)
    logger.close

    [status, headers, response]
  end

  private

  def log_message(env, status, headers)
    "Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}\n" \
    "Handler: #{env['simpler.controller'].class}##{env['simpler.action']}\n" \
    "Parameters: #{env['simpler.params']}\n" \
    "Response: #{status} #{headers['Content-Type']} #{env['simpler.render_view']}\n" \
  end
end