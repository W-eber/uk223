require 'rails_helper'

RSpec.describe Debt, type: :model do
  let(:group) { Group.create(group_code: '12345') }
  let(:payer) { User.create(username: 'payer', password: 'password') }
  let(:payee) { User.create(username: 'payee', password: 'password') }

  context 'validations' do
    it 'is valid with valid attributes' do
      debt = Debt.new(amount: 100, description: 'Test Debt', payer: payer, payee: payee, group: group)
      expect(debt).to be_valid
    end

    it 'is not valid without an amount' do
      debt = Debt.new(description: 'Test Debt', payer: payer, payee: payee, group: group)
      expect(debt).not_to be_valid
    end

    it 'is not valid without a description' do
      debt = Debt.new(amount: 100, payer: payer, payee: payee, group: group)
      expect(debt).not_to be_valid
    end

    it 'is not valid with amount less than or equal to 0' do
      debt = Debt.new(amount: 0, description: 'Invalid Debt', payer: payer, payee: payee, group: group)
      expect(debt).not_to be_valid
    end
  end

  context 'default values' do
    it 'sets is_paid to false by default' do
      debt = Debt.create(amount: 100, description: 'Test Debt', payer: payer, payee: payee, group: group)
      expect(debt.is_paid).to eq(false)
    end
  end
end
