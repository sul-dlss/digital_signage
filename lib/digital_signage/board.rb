require 'faraday'

module DigitalSignage
  class Board
    def self.telemetry(hash)
      puts "TELEMETRY: #{hash.inspect}"

      response = Faraday.new(ENV['TELEMETRY_BATCH_API_URL']).post do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = hash.to_json
      end

      puts response.body
    end
  end
end
