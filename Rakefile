#!/usr/bin/env rake

begin
	require 'hoe'
rescue LoadError
	abort "This Rakefile requires 'hoe' (gem install hoe)"
end

# Sign gems
Hoe.plugin :signing

Hoe.spec 'strelka-metriks' do
	self.readme_file = 'README.rdoc'
	self.history_file = 'History.rdoc'
	self.extra_rdoc_files = FileList[ '*.rdoc' ]

	self.developer 'FIX', 'FIX' # (name, email)

	self.dependency 'strelka', '~> 0.1'
	self.dependency 'rspec', '~> 2.7', :developer

	self.require_ruby_version( '~> 1.9' )
end

