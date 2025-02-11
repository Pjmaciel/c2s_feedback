# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'associations' do
    it { should have_one(:client_profile).dependent(:destroy) }
    it { should have_one(:attendant_profile).dependent(:destroy) }
    it { should have_one(:manager_profile).dependent(:destroy) }
    it { should have_many(:evaluations) }
    it { should have_many(:received_evaluations).class_name('Evaluation') }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:role) }
    it { should validate_inclusion_of(:role).in_array(%w[client attendant manager]) }
  end

  describe 'devise modules' do
    it { should validate_presence_of(:password) }
    it { should validate_confirmation_of(:password) }
  end

  describe 'role methods' do
    context 'when role is client' do
      before { user.role = 'client' }

      it { expect(user.client?).to be true }
      it { expect(user.attendant?).to be false }
      it { expect(user.manager?).to be false }
    end

    context 'when role is attendant' do
      before { user.role = 'attendant' }

      it { expect(user.client?).to be false }
      it { expect(user.attendant?).to be true }
      it { expect(user.manager?).to be false }
    end

    context 'when role is manager' do
      before { user.role = 'manager' }

      it { expect(user.client?).to be false }
      it { expect(user.attendant?).to be false }
      it { expect(user.manager?).to be true }
    end
  end

  describe '#profile' do
    context 'when user is a client' do
      let(:client) { create(:user, :with_client_profile) }

      it 'returns the client profile' do
        expect(client.profile).to eq(client.client_profile)
      end
    end

    context 'when user is an attendant' do
      let(:attendant) { create(:user, :with_attendant_profile) }

      it 'returns the attendant profile' do
        expect(attendant.profile).to eq(attendant.attendant_profile)
      end
    end

    context 'when user is a manager' do
      let(:manager) { create(:user, :with_manager_profile) }

      it 'returns the manager profile' do
        expect(manager.profile).to eq(manager.manager_profile)
      end
    end
  end
end