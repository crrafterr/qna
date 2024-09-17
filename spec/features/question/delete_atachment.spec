require 'rails_helper'

feature 'Delete attachment' do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }

  before do
    attach_file_to(question)
  end

  describe 'Authenticated user', js: true do
    scenario 'Author' do
      sign_in(author)
      visit question_path(question)
      within ".attachment-file-#{question.files.first.id}" do
        click_on 'Delete attachment'
      end

      within ".question" do
        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario 'User' do
      sign_in(user)
      visit question_path(question)

      within ".attachment-file-#{question.files.first.id}" do
        expect(page).to_not have_link 'Delete attachment'
      end
    end
  end

  scenario 'Not authenticated user' do
    visit question_path(question)

    within ".attachment-file-#{question.files.first.id}" do
      expect(page).to_not have_link 'Delete attachment'
    end
  end
end
