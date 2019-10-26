module Simpler
  class Router
    class Route
      CAPTURE_PARAM_REGEXP = /\/:(.+?)(?:\/|$)/

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @path_regexp = build_regexp(path)
        @controller = controller
        @action = action
        @params = {}
      end

      def match?(method, path)
        @method == method && parse_path(path)
      end

      private

      def build_regexp(path)
        path.gsub(CAPTURE_PARAM_REGEXP, '\/(?<\1>.+)') + '$'
      end

      def parse_path(path)
        match = path.match(@path_regexp)

        return false if match.nil?

        match.named_captures.each do |k, v|
          @params[k.to_sym] = v
        end
      end
    end
  end
end
