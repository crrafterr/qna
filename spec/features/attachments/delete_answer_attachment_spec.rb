require 'rails_helper'

feature 'User can remove his answer attachments' do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:answer) { create(:answer, question: question, user: author) }

  before do
    attach_file_to(answer)
  end

  describe 'Authenticated user', js: true do
    scenario 'author of the answer delete the attachment' do
      sign_in(author)
      visit question_path(question)

      within ".attachment-file-#{answer.files.first.id}" do
        click_on 'Delete attachment'
      end

      within ".answer-#{answer.id}" do
        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario 'user of the answer can not delete the attachment' do
      sign_in(user)
      visit question_path(question)

      within ".attachment-file-#{answer.files.first.id}" do
        expect(page).to_not have_link 'Delete attachment'
      end
    end
  end

  scenario 'Non-logged in user delete question attachment' do
    visit question_path(question)

    within ".attachment-file-#{answer.files.first.id}" do
      expect(page).to_not have_link 'Delete attachment'
    end
  end
end
