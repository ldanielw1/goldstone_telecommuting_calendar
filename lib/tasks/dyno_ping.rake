desc "Pings PING_URL to keep a dyno alive"
task :dyno_ping do
  require "net/http"

  uri = URI("https://gp-cc-calendar-monitor.herokuapp.com/")
  Net::HTTP.get_response(uri)
end
