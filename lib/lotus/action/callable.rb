module Lotus
  module Action
    module Callable
      def call(params)
        _rescue do
          @session = _session(params)
          super      _params(params)
        end

        [status, headers, body]
      end

      attr_reader :session
      attr_writer :status, :headers, :body

      def status
        @status || 200
      end

      def headers
        @headers || {}
      end

      def body
        [@body.to_s]
      end

      private
      def _session(params)
        params['rack.session'] ||= {}
      end

      def _params(params)
        params.fetch('router.params', params)
      end

      def _rescue
        begin
          yield
        rescue
          @status = 500
          @body   = 'Internal Server Error'
        end
      end
    end
  end
end
