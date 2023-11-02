Given("I have a message {string}") do |message|
  @message = message
end

When("I call the Gpt3Service") do
  @response = Gpt3Service.call(@message)
end

Then("the response should be {string}") do |expected_response|
  expect(@response).to include(expected_response)
end