require 'rails_helper'

RSpec.describe Evaluation, type: :model do
  describe 'associations' do
    it { should belong_to(:attendant).class_name('User') }
    it { should belong_to(:client).class_name('User') }
  end

  describe 'validations' do
    it { should validate_presence_of(:score) }
    it { should validate_numericality_of(:score).only_integer.is_greater_than_or_equal_to(0).is_less_than_or_equal_to(10) }
    it { should validate_presence_of(:comment) }
    it { should validate_length_of(:comment).is_at_least(10).is_at_most(1000) }
    it { should validate_presence_of(:evaluation_date) }
  end

  describe 'custom validations' do
    let(:evaluation) { build(:evaluation) }

    context 'client_must_be_client validation' do
      it 'is valid when client has client role' do
        expect(evaluation).to be_valid
      end

      it 'is invalid when client has different role' do
        evaluation.client.role = 'attendant'
        expect(evaluation).not_to be_valid
        expect(evaluation.errors[:client]).to include('must have client role')
      end
    end

    context 'attendant_must_be_attendant validation' do
      it 'is valid when attendant has attendant role' do
        expect(evaluation).to be_valid
      end

      it 'is invalid when attendant has different role' do
        evaluation.attendant.role = 'client'
        expect(evaluation).not_to be_valid
        expect(evaluation.errors[:attendant]).to include('must have attendant role')
      end
    end

    context 'evaluation_date_cannot_be_in_future validation' do
      it 'is valid when date is in the past' do
        evaluation.evaluation_date = 1.day.ago
        expect(evaluation).to be_valid
      end

      it 'is invalid when date is in the future' do
        evaluation.evaluation_date = 1.day.from_now
        expect(evaluation).not_to be_valid
        expect(evaluation.errors[:evaluation_date]).to include('cannot be in the future')
      end
    end
  end

  describe 'callbacks' do
    let(:evaluation) { build(:evaluation) }

    it 'triggers notify_managers after create' do
      expect(evaluation).to receive(:notify_managers)
      evaluation.save
    end

    it 'triggers notify_attendant after create' do
      expect(evaluation).to receive(:notify_attendant)
      evaluation.save
    end
  end
end