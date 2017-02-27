#! /usr/bin/env ruby
#
#   metrics-turbine
#
# DESCRIPTION:
#   Will output data from turbine.stream
#
# OUTPUT:
#   metric data
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: eventmachine
#   gem: em-http-request
#   gem: json
#
# USAGE:
#
# NOTES:
#
# LICENSE:
#   Copyright 2016 Chris McFee <cmcfee@kent.edu>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.

require 'sensu-plugin/metric/cli'
require 'em-eventsource'
require 'json'

class PodsMetrics < Sensu::Plugin::Metric::CLI::Graphite
  option :url,
         short: '-u URL',
         description: 'Full URL path to the turbine stream',
         required: true

  option :thread_pool,
         short: '-t POOLNAME',
         description: 'The pool name requested',
         required: true

  option :scheme,
         short: '-s SCHEME',
         description: 'Graphite storage scheme'

  def initialize
    super
    @url = config[:url]
    @thread_pool = config[:thread_pool]
    @scheme = config[:scheme]
  end

  def run
    config[:scheme] = @scheme
    info = %w(rollingCountSuccess currentActiveCount currentConcurrentExecutionCount rollingMaxConcurrentExecutionCount rollingCountBadRequests)
    EM.run do
      source = EventMachine::EventSource.new(@url)
      source.start
      source.message do |message|
        json_data = JSON.parse(message)
        if json_data['name'] == @thread_pool
          info.size.times { |i| output "#{@scheme}.#{json_data['name']}.#{info[i]}", json_data[info[i]] }
          source.close
          ok
        end
      end
    end
  end
end
