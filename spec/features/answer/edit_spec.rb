require 'rails_helper'

feature 'User can edit his answer' do
  given!(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Non-logged in user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario "User can not edit other user's answers" do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit answer'
    end
  end

  describe 'Authenticated user' do
    before { sign_in(author) }
    before do
      visit question_path(question)
      click_on 'Edit answer'
    end

    scenario 'edits his answer', js: true do
      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with attach files', js: true do
      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        attach_file 'Answers files', [ "#{Rails.root.join('spec/rails_helper.rb')}", "#{Rails.root.join('spec/spec_helper.rb')}" ]
        click_on 'Save'

        expect(page).to_not have_selector 'file'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his answer with errors', js: true do
      within ".answers" do
        fill_in 'Your answer', with: ''
        click_on 'Save'


        expect(page).to have_content answer.body
        expect(page).to have_selector('textarea', id: 'answer_body')
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'edits his answer with link', js: true do
      within '.answers' do
        click_on 'add link'

        fill_in 'Link name', with: 'Test'
        fill_in 'Url', with: 'http://test.local'

        click_on 'Save'

        expect(page).to have_link 'Test', href: 'http://test.local'
        expect(page).to_not have_selector 'textfield'
      end
    end
  end
end
