class Api::V1::SubscriptionsController < ApplicationController

  def index
    if Customer.where("id = #{params[:customer_id]}").count == 0
      render json: { data: { errors: "Customer does not exist"} }, status: 401
    else
      customer = Customer.find(params[:customer_id])
      render json: SubscriptionSerializer.new(customer.subscriptions)
    end
  end

  def create
    customer = Customer.find(params[:customer_id])
    subscription = Subscription.create(title: params[:title],
              price: params[:price],
              frequency: params[:frequency],
              tea_id: params[:tea_id],
              customer_id: params[:customer_id])
    if subscription.save
      render json: SubscriptionSerializer.new(subscription)
    else
      render json: { data: { errors: subscription.errors.full_messages} }, status: 401
    end

  end

  def update
    if Subscription.where("id = #{params[:id]}").count == 0
      render json: { data: { errors: "Subscription does not exist"} }, status: 401
    else
      subscription = Subscription.update(params[:id], subscription_params)
      if subscription.save
        render json: SubscriptionSerializer.new(subscription)
      else
        binding.pry
        render json: { data: { errors: subscription.errors.full_messages} }, status: 401
      end
    end


  end

  private

  def subscription_params
    params.permit(:title, :price, :status, :frequency, :customer_id, :tea_id)
  end

end
