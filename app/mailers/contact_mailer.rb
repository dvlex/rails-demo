class ContactMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.new_contact_form.subject
  #
  def new_contact_form(email, name)
    @name = name

    mail to: email, subject: "Thank you for contacting us"
  end
end
