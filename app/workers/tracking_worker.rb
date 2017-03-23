require 'sendgrid-ruby'

class TrackingWorker
  include Sidekiq::Worker

  def perform(postcard_id, event_name, event_location, event_time)
    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    user = User.where(verification_postcard_id: postcard_id).first

    from = Email.new(email: 'test@lob.com')
    subject = 'Lob Webhooks Demo - Notification'
    to = Email.new(email: user.email)
    email_content = "Your postcard is on it's way! \n\n Tracking Event: #{event_name} \n Location: #{event_location} \n Time: #{event_time}"
    content = Content.new(type: 'text/plain', value: email_content)
    mail = Mail.new(from, subject, to, content)

    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end
end
