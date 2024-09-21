require 'rails_helper'

shared_examples_for Voteble do
  describe 'Associations' do
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe '#vote_up' do
    it 'user can vote up' do
      voteble.vote_up(first_user)

      expect(voteble.total_votes).to eq 1
    end

    it 'user can vote up once' do
      voteble.vote_up(first_user)
      voteble.vote_up(first_user)

      expect(voteble.total_votes).to eq 1
    end
  end

  describe '#vote_down' do
    it 'user can vote down' do
      voteble.vote_down(first_user)

      expect(voteble.total_votes).to eq (-1)
    end

    it 'user can vote down once' do
      voteble.vote_down(first_user)
      voteble.vote_down(first_user)

      expect(voteble.total_votes).to eq (-1)
    end
  end

  describe '#total_vote' do
    let!(:first_vote) { create(:vote, user: first_user, voteble: voteble, vote: 1) }
    let!(:second_vote) { create(:vote, user: second_user, voteble: voteble, vote: 1) }

    it 'total vote sum' do
      expect(voteble.total_votes).to eq 2
    end
  end

  describe '#recall' do
    it 'user can recall vote' do
      voteble.vote_up(first_user)
      voteble.recall(first_user)

      expect(voteble.total_votes).to eq 0
    end
  end

  describe 'Author' do
    it 'can not vote' do
      voteble.vote_up(author)

      expect(voteble.total_votes).to eq 0
    end
  end
end
