class Api::V1::SubscriptionsController < ApplicationController

  def index
    customer = Customer.find(params[:customer_id])
    render json: SubscriptionSerializer.new(customer.subscriptions)
  end

  def create
    # binding.pry
    customer = Customer.find(params[:customer_id])
    subscription = Subscription.create(title: params[:title],
              price: params[:price],
              frequency: params[:frequency],
              tea_id: params[:tea_id],
              customer_id: params[:customer_id])
    if subscription.save
      render json: SubscriptionSerializer.new(subscription)
    else
      render json: { data: { errors: user.errors.messages.values.join} }, status: 401
    end

  end

  def update
    subscription = Subscription.update(params[:id], subscription_params)
    if subscription.save
      render json: SubscriptionSerializer.new(subscription)
    else
      render json: { data: { errors: user.errors.messages.values.join} }, status: 401
    end
  end

  private

  def subscription_params
    params.permit(:title, :price, :status, :frequency, :customer_id, :tea_id)
  end

end
