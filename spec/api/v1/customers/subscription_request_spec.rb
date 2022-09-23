require 'rails_helper'

RSpec.describe 'Tea Subscription API' do
  it 'returns all subscriptions of a certain customer' do

    customer1 = Customer.new(first_name: "Jim", last_name: "Raddle", email: "test@test.com", address: "drury lane")
    tea1 = Tea.new(title: "black tea", description: "some pretty good black tea", temperature: 80, brew_time: 5)
    tea2 = Tea.new(title: "green tea", description: "some pretty green black tea", temperature: 100, brew_time: 15)

    subscription1 = Subscription.create(customer: customer1, tea: tea1, title: "babys first subscription", price: "50 dollars", status: "cancelled", frequency: "weekly")
    subscription2 = Subscription.create(customer: customer1, tea: tea2, title: "babys second subscription", price: "40 dollars", status: "active", frequency: "monthly")

    get "/api/v1/customers/#{customer1.id}/subscriptions"

    expect(response).to be_successful
    response_body = JSON.parse(response.body, symbolize_names: true)

    expect(response_body[:data][0][:attributes][:title]).to eq("babys first subscription")
    expect(response_body[:data][1][:attributes][:title]).to eq("babys second subscription")

    expect(response_body[:data][0][:attributes][:price]).to eq("50 dollars")
    expect(response_body[:data][1][:attributes][:price]).to eq("40 dollars")

    expect(response_body[:data][0][:attributes][:status]).to eq("cancelled")
    expect(response_body[:data][1][:attributes][:status]).to eq("active")

    expect(response_body[:data][0][:attributes][:frequency]).to eq("weekly")
    expect(response_body[:data][1][:attributes][:frequency]).to eq("monthly")

  end

  it 'returns all subscriptions of a given customer - sad path' do
    customer1 = Customer.new(first_name: "Jim", last_name: "Raddle", email: "test@test.com", address: "drury lane")
    tea1 = Tea.new(title: "black tea", description: "some pretty good black tea", temperature: 80, brew_time: 5)
    tea2 = Tea.new(title: "green tea", description: "some pretty green black tea", temperature: 100, brew_time: 15)

    subscription1 = Subscription.create(customer: customer1, tea: tea1, title: "babys first subscription", price: "50 dollars", status: "cancelled", frequency: "weekly")
    subscription2 = Subscription.create(customer: customer1, tea: tea2, title: "babys second subscription", price: "40 dollars", status: "active", frequency: "monthly")

    get "/api/v1/customers/99999999/subscriptions"

    response_body = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response_body[:data][:errors]).to eq("Customer does not exist")

  end

  it 'creates a new subscription' do
    customer1 = Customer.create(first_name: "Jim", last_name: "Raddle", email: "test@test.com", address: "drury lane")
    tea1 = Tea.create(title: "black tea", description: "some pretty good black tea", temperature: 80, brew_time: 5)
    tea2 = Tea.create(title: "green tea", description: "some pretty green black tea", temperature: 100, brew_time: 15)

    subscription_params = {
      tea_id: "#{tea1.id}",
      title: "first subscription",
      price: "40 dollars",
      frequency: "weekly"
    }

    post "/api/v1/customers/#{customer1.id}/subscriptions", params: subscription_params

    expect(response).to be_successful
    response_body = JSON.parse(response.body, symbolize_names: true)

    expect(response_body[:data][:attributes][:title]).to eq("first subscription")
    expect(response_body[:data][:attributes][:price]).to eq("40 dollars")
    expect(response_body[:data][:attributes][:frequency]).to eq("weekly")
    expect(response_body[:data][:attributes][:status]).to eq("active")

  end

  it 'creates a new subscription - sad path' do

    customer1 = Customer.create(first_name: "Jim", last_name: "Raddle", email: "test@test.com", address: "drury lane")
    tea1 = Tea.create(title: "black tea", description: "some pretty good black tea", temperature: 80, brew_time: 5)
    tea2 = Tea.create(title: "green tea", description: "some pretty green black tea", temperature: 100, brew_time: 15)

    subscription_params = {
      title: "first subscription",
      price: "40 dollars",
      frequency: "weekly"
    }

    post "/api/v1/customers/#{customer1.id}/subscriptions", params: subscription_params
    response_body = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response_body[:data][:errors]).to eq(["Tea must exist"])
  end

  it 'cancels a subscription' do
    customer1 = Customer.create(first_name: "Jim", last_name: "Raddle", email: "test@test.com", address: "drury lane")
    tea1 = Tea.create(title: "black tea", description: "some pretty good black tea", temperature: 80, brew_time: 5)

    subscription1 = Subscription.create(customer: customer1, tea: tea1, title: "babys first subscription", price: "50 dollars", status: "active", frequency: "weekly")
    subscription_params = {
      status: "cancelled"
    }
    patch "/api/v1/customers/#{customer1.id}/subscriptions/#{subscription1.id}", params: subscription_params

    expect(response).to be_successful
    response_body = JSON.parse(response.body, symbolize_names: true)

    expect(response_body[:data][:attributes][:title]).to eq("babys first subscription")
    expect(response_body[:data][:attributes][:price]).to eq("50 dollars")
    expect(response_body[:data][:attributes][:frequency]).to eq("weekly")
    expect(response_body[:data][:attributes][:status]).to eq("cancelled")

  end

  it 'cancels a subscription - sad path' do

    customer1 = Customer.create(first_name: "Jim", last_name: "Raddle", email: "test@test.com", address: "drury lane")
    tea1 = Tea.create(title: "black tea", description: "some pretty good black tea", temperature: 80, brew_time: 5)

    subscription1 = Subscription.create(customer: customer1, tea: tea1, title: "babys first subscription", price: "50 dollars", status: "active", frequency: "weekly")
    subscription_params = {
      status: "cancelled"
    }
    patch "/api/v1/customers/#{customer1.id}/subscriptions/999999999", params: subscription_params
    expect(response).to_not be_successful
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response_body[:data][:errors]).to eq("Subscription does not exist")

  end

end
