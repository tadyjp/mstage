r = Nginx::Request.new

Nginx.errlogger Nginx::LOG_NOTICE, "Nginx::Request#host: #{r.var.host}"
Nginx.errlogger Nginx::LOG_NOTICE, "ENV['REDIS_PORT_6379_TCP_ADDR']: #{ENV['REDIS_PORT_6379_TCP_ADDR']}"

layer_id = r.var.host.split('.')[0].sub(/layer/, '')
stack_id = r.var.host.split('.')[1].sub(/stack/, '')

redis = Redis.new ENV['REDIS_PORT_6379_TCP_ADDR'], 6379

Nginx.errlogger Nginx::LOG_NOTICE, "stack:#{stack_id}, layer:#{layer_id}"
container_ip = redis.get "stack:#{stack_id}:layer:#{layer_id}:ip"

Nginx.errlogger Nginx::LOG_NOTICE, "container_host: #{container_ip}:3000"

if container_ip && container_ip != ''
  "#{container_ip}:3000"
else
  Nginx.echo "waiting..."
  ''
end

