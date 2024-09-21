require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:links).dependent(:destroy) }

  it { should have_many_attached(:files) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  describe '#best!' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:first_answer) { create(:answer, question: question, user: user) }
    let(:second_answer) { create(:answer, question: question, user: user) }

    context 'when there are not best answers' do
      it 'set best' do
        first_answer.best!

        expect(first_answer.best).to be true
        expect(second_answer.best).to be false
      end
    end

    context 'when there is best answer' do
      before do
        second_answer.best!
      end

      it "another answer is best" do
        first_answer.best!

        expect(first_answer.best).to be true
        expect(question.answers.best.count).to eq 1
      end
    end
  end

  it_behaves_like Voteble
end
