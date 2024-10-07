class NewAnswerNotificationMailer < ApplicationMailer
  def new_answer(user, answer)
    @answer = answer

    mail to: user.email, subject: "New answer notification"
  end
end
