require 'eventmachine'
require 'json-rpc-client'
require 'fiber'

class JsonRpcHttpClient
  def initialize(url)
    @url = url
  end

  def _rpc_call(method, *args)
    err = nil
    res = nil
    EventMachine.run do
      # To use the syncing behaviour, use it in a fiber.
      fiber = Fiber.new do
        rpc = JsonRpcClient.new(
          @url, {asynchronous_calls: false}
        )
        begin
          res = rpc.send(method, *args)
        rescue Exception => e
          err = e.message
        end
        EventMachine.stop
      end
      fiber.resume
    end
    [err,res]
  end

  def method_missing(method, *args)
    _rpc_call method, *args
  end
end

