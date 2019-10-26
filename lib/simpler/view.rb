require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      case render_as
      when :plain
        render_arg
      when :inline
        ERB.new(render_arg).result(binding)
      else
        template = File.read(template_path)
        ERB.new(template).result(binding)
      end
    end

    private

    def render_as
      @env['simpler.render_as']
    end

    def render_arg
      @env['simpler.render_arg']
    end

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

    def template_path
      path = template || [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

  end
end
