# module Services
#   class Gpt3Service
#     require 'net/http'
#     require 'json'

#     endpoint = 'https://api.openai.com/v1/engines/davinci/completions'
#     api_key = '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'

#     def self.generate_tailored_resume(job_description, existing_resume)
#       prompt = "Tailor the following resume to match the job description:\n\nJob Description: #{job_description}\n\nResume: #{existing_resume}\n\nTailored Resume:"
#       request_body = {
#         prompt: prompt,
#         max_tokens: 1000
#       }

#       # Convert the request body to JSON
#       request_json = request_body.to_json

#       uri = URI(endpoint)
#       http = Net::HTTP.new(uri.host, uri.port)
#       http.use_ssl = true
#       request = Net::HTTP::Post.new(uri.path, { 'Content-Type' => 'application/json' })
#       request['Authorization'] = "Bearer #{api_key}"
#       request.body = request_json

#       response = http.request(request)

#       if response.code == '200'
#         result = JSON.parse(response.body)
#         tailored_resume = result['choices'][0]['text']
#         return tailored_resume
#       else
#         # Handle errors, e.g., by logging or raising an exception
#         flash[:alert] = "Error"
#         return nil
#       end
#     end
#   end
# end


class Gpt3Service
  include HTTParty

  attr_reader :api_url, :options, :model, :message

  def initialize(message, model = 'gpt-3.5-turbo')
    api_key = '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'
    @options = {
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{api_key}"
      }
    }
    @api_url = 'https://api.openai.com/v1/chat/completions'
    @model = model
    @message = message
  end

  def call
    body = {
      model: @model,
      messages: [{ role: 'user', content: message }]
    }
    response = HTTParty.post(api_url, body: body.to_json, headers: options[:headers], timeout: 10)
    raise response['error']['message'] unless response.code == 200

    response['choices'][0]['message']['content']
  end

  class << self
    def call(message, model = 'gpt-3.5-turbo')
      new(message, model).call
    end
  end
end