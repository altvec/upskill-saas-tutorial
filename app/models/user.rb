class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :plan
  has_one :profile
  
  attr_accessor :stripe_card_token
  # If Pro user passes validations (email, passwords, etc),
  # then call Stripe and tell to set up a subscription upon
  # charging the customer's card. Stripe respons back with
  # customer data and we store customer.id as the customer 
  # token and save the user
  def save_with_subcription
    if valid?
      customer = Stripe::Customer.create(description: email, plan: plan_id, card: stripe_card_token)
      self.stripe_customer_token = customer.id
      save!
    end
  end
end
