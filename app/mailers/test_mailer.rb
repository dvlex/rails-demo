class TestMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.test_mailer.welcome_email.subject
  #
  def welcome_email(email, name)
    @name = name
    @greeting = "Hi"

    mail to: email, subject: "Bienvenido a Lexdrel"
  end
end
