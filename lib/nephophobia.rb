require "./lib/aws"
require "nephophobia/client"

#def request(params)
#
#  body = AWS.signed_params(
#    params,
#      {
#        :aws_access_key_id  => @aws_access_key_id,
#        :hmac               => @hmac,
#        :host               => @host,
#        :path               => @path,
#        :port               => @port,
#        :version            => '2010-08-31'
#      }
##    )
#
#end

#response = @connection.request({
#:body       => body,
#:expects    => 200,
#:headers    => { 'Content-Type' => 'application/x-www-form-urlencoded' },
#:idempotent => idempotent,
#:host       => @host,
#:method     => 'POST',
#:parser     => parser
#})
