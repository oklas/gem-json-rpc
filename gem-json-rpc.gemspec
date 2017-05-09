Gem::Specification.new do |s|
  s.name        = 'gem-json-rpc'
  s.license     = 'MIT'
  s.version     = '0.1.0'
  s.date        = '2017-02-21'
  s.summary     = "em json rpc"
  s.description = "eventmachine based simplificators of json-rpc in ruby"
  s.authors     = ["Serguei Okladnikov"]
  s.email       = 'oklaspec@gmail.com'
  s.files       = ["lib/JsonRpcHttpServer.rb", "lib/JsonRpcHttpClient.rb"]
  s.homepage    = 'http://github.com/oklas'

  s.add_dependency 'formtastic'
  s.add_dependency 'eventmachine'
  s.add_dependency 'json-rpc-client'
  s.add_dependency 'eventmachine_httpserver'#, :require => 'evma_httpserver'
end
