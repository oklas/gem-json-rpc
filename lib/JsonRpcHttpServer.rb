require 'eventmachine'
require 'evma_httpserver'
require 'json'

class JsonRpcHttpServer < EM::Connection
  include EM::HttpServer

  def post_init
    super
    no_environment_strings
  end

  def id
    1
  end

  def process_http_request
    err = nil
    response = EM::DelegatedHttpResponse.new(self)
    response.status = 200
    response.content_type 'application/json'
    begin
      req = JSON.parse( @http_post_content )
      method = req['method']
      unless self.respond_to? method
        err = {"code": -32601, "message": "Method not found"}
        raise
      end
      self.method(method).call( *req['params'] ) do |err,res|
        err = err.nil? ? nil :
          { "code": -32600, "message": err }
        res = err.nil? ?
          { jsonrpc: "2.0", result: res, id: id } :
          { jsonrpc: "2.0", error: err, id: id }
        response.content = res.to_json
        response.send_response
      end
    rescue Exception => e
      if err.nil?
        err = { "code": -32600, "message": e.message }
      end
    end
    unless err.nil?
      res = { jsonrpc: "2.0", error: err, id: id }
      response.content = res.to_json
      response.send_response
    end
  end
end

