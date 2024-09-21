require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to :user }
  it { should have_one(:badge).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should have_many_attached(:files) }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :badge }

  describe "Voteble" do
    it_behaves_like Voteble do
      let(:author) { create(:user) }
      let(:first_user) { create(:user) }
      let(:second_user) { create(:user) }
      let(:voteble) { create(:question, user: author) }
    end
  end
end
