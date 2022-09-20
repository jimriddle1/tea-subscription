require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'relationships' do
    it { should have_many(:subscriptions) }

  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:status) }
    it { should validate_numericality_of(:frequency) }
  end

end
