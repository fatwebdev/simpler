require_relative 'view'

module Simpler
  class Controller
    HEADERS = {
      plain: 'text/plain',
      html: 'text/html',
      inline: 'text/html'
    }.freeze

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      send(action)
      write_response
      set_default_headers

      @response.finish
    end

    def status(code)
      @response.status = code
    end

    def headers
      @response
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = HEADERS[render_as || :html]
    end

    def render_as
      @request.env['simpler.render_as']
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.env['simpler.params'].merge!(@request.params)
    end

    def render(*template, **options)
      render_options = options.select { |k, _v| %i[inline plain].include?(k) }

      if render_options.empty?
        @request.env['simpler.template'] = template.first
      else
        @request.env['simpler.render_as'] = render_options.keys.first
        @request.env['simpler.render_arg'] = render_options.values.first
      end
    end

  end
end
