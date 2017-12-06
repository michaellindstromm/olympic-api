class Rack::Attack

    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

    throttle('req/ip', limit: 1, period: 30) do |req| 
        req.ip 
    end

    self.throttled_response = lambda do |env|
        now = Time.now
        match_data = env['rack.attack.match_data']

        headers = {
            'X-RateLimit-Limit' => match_data[:limit].to_s,
            'X-RateLimit-Remaining' => '0',
            'X-RateLimit-Reset' => (now + (match_data[:period] - now.to_i % match_data[:period])).to_s
        }

        [ 429, headers, ["Throttled. Rate limit reached. Please wait until throttle is reset."]]
    end
end