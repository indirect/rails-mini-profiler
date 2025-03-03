# frozen_string_literal: true

module RailsMiniProfiler
  module Tracers
    class Tracer
      class << self
        def subscribes_to
          []
        end

        def presents
          TracePresenter
        end

        def build_from(event)
          new(event).trace
        end
      end

      def initialize(event)
        @event = event_data(event)
      end

      def trace
        Trace.new(**@event)
      end

      private

      def event_data(event)
        start = (event.time.to_f * 100_000).to_i
        finish = (event.end.to_f * 100_000).to_i
        {
          name: event.name,
          start: start,
          finish: finish,
          duration: finish - start,
          allocations: event.allocations,
          backtrace: Rails.backtrace_cleaner.clean(caller),
          payload: event.payload
        }
      end
    end
  end
end
