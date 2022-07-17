Gem::Specification.new do |spec|
  spec.name         = "webmockdump"
  spec.version      = "0.0.0"
  spec.summary      = "Patch for webmock that instead of halting is doing and dumping the request for easier mocks development."

  spec.author       = "Victor Maslov aka Nakilon"
  spec.email        = "nakilon@gmail.com"
  spec.license      = "MIT"
  spec.metadata     = {"source_code_uri" => "https://github.com/nakilon/webmockdump"}

  spec.add_dependency "webmock"

  spec.files        = %w{ LICENSE webmockdump.gemspec lib/webmockdump.rb }
end
