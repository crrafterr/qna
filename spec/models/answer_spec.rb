require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of :body }

  describe 'Set best answer' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:first_answer) { create(:answer, question: question, user: user) }
    let(:second_answer) { create(:answer, question: question, user: user) }

    it 'Set best' do
      first_answer.best!

      expect(first_answer.best).to be true
      expect(second_answer.best).to be false
    end

    it "another answer is best" do
      second_answer.best!
      first_answer.best!

      expect(first_answer.best).to be true
      expect(question.answers.best.count).to eq 1
    end
  end
end
