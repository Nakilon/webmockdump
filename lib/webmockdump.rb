require "webmock"

WebMock.enable_net_connect!

# executes the request to make us know what to stub it with
WebMock.module_eval do
  class << self
    alias_method :old_net_connect_allowed?, :net_connect_allowed?
    define_method(:net_connect_allowed?){ |*| true }
  end
end
WebMock.after_request real_requests_only: true do |req_signature, response|
  # next unless WebMock.enabled?
  next if WebMock.old_net_connect_allowed? req_signature.uri
  puts "Request:\n#{req_signature}"
  if response.body
    dup = response.dup
    File.write "body.txt", dup.body
    dup.body = "<<< FILE: ./body.txt >>>"
    puts "Response:\n#{dup.pretty_inspect}"
  else
    puts "Response:\n#{response.pretty_inspect}"
  end
  raise WebMock::NetConnectNotAllowedError.new req_signature
end
# https://github.com/bblimke/webmock/issues/469#issuecomment-752411256
WebMock::HttpLibAdapters::NetHttpAdapter.instance_variable_get(:@webMockNetHTTP).class_eval do
  old_request = instance_method :request
  define_method :request do |request, &block|
    old_request.bind(self).(request, &block).tap do |response|
      response.uri = request.uri
    end
  end
end
