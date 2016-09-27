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
require 'eventmachine'
require 'em-http'
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
    http = EM::HttpRequest.new(@url, keepalive: true, connect_timeout: 0, inactivity_timeout: 0)
    info = %w(rollingCountSuccess currentActiveCount currentConcurrentExecutionCount rollingMaxConcurrentExecutionCount rollingCountBadRequests)
    EventMachine.run do
      req = http.get(head: { 'accept' => 'application/json' })
      req.stream do |chunk|
        unless chunk.strip.empty?
          if chunk.include?('data: ') && !chunk.include?('ping')
            json_data = (chunk.split(': ')[1]).strip!
            unless json_data.nil?
              if json_data.end_with?('}')
                message = JSON.parse(json_data)
                if message['name'] == @thread_pool
                  info.size.times { |i| output "#{config[:scheme]}.#{message['name']}.#{info[i]}.#{message[info[i]]}" unless message[info[i]].nil? }
                  EventMachine.stop
                end
              end
            end
          end
        end
      end
    end
    ok
  end
end
