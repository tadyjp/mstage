nx::Request.new

Nginx.errlogger Nginx::LOG_NOTICE, "Nginx::Request#host: #{r.var.host}"
Nginx.errlogger Nginx::LOG_NOTICE, "ENV['REDIS_PORT_6379_TCP_ADDR']: #{ENV['REDIS_PORT_6379_TCP_ADDR']}"

subdomain = r.var.host.split('.')[0]

redis = Redis.new ENV['REDIS_PORT_6379_TCP_ADDR'], 6379
container_ip = redis.get "#{subdomain}:ip"

Nginx.errlogger Nginx::LOG_NOTICE, "container_host: #{container_ip}:3000"

if container_ip
  "#{container_ip}:3000"
else
  Nginx.echo "waiting..."
  ''
end

