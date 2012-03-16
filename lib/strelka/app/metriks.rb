# -*- ruby -*-
# vim: set nosta noet ts=4 sw=4:
# encoding: utf-8

require 'metriks'
require 'metriks/reporter/logger'

require 'strelka' unless defined?( Strelka )
require 'strelka/app' unless defined?( Strelka::App )


# Strelka::App plugin module for Metriks statistics and analysis.
module Strelka::App::Metriks
	extend Strelka::App::Plugin

	run_before :routing, :templating, :filters


	### Set up a Logger reporter
	def run( * )
		@metriks_key = self.conn.app_id

		self.log.info "strelka-metriks: Setting up a Metriks reporter."
		Metriks::Reporter::Logger.new( :logger => Strelka.log ).start

		self.log.info "strelka-metriks: Setting up a proctitle reporter"
		reporter = Metriks::Reporter::ProcTitle.new( :interval => 5 )
		reporter.add 'reqs', 'sec' do
			Metriks.meter( "#@metriks_key.requests" ).one_minute_rate
		end
		reporter.start

		super
	end


	### Set up the timer for timing the total request cycle.
	def fixup_request( request )
		self.log.debug "strelka-metriks: total timer start"
		@total_timer = Metriks.timer( "#@metriks_key.duration.total" )
		return super
	end


	### Mark and time the app.
	def handle_request( request )
		Metriks.meter( "#@metriks_key.requests" ).mark

		response = nil
		Metriks.timer( "#@metriks_key.duration.app" ).time do
			response = super
		end

		self.log.debug "Returning response: %p" % [ response ]
		return response
	end


	### Finish the total timer.
	def fixup_response( response )
		response = super
		self.log.debug "strelka-metriks: total timer stop"
		@total_timer.stop
		return response
	end


end # module Strelka::App::Metriks


