class CustomerioMailboxerNotificationMailer < ActionMailer::Base

  def self.send_email(message, receiver)
    $customerio.identify(id: receiver.id, email: receiver.email, created_at: receiver.created_at.to_i, name: receiver.name)
    $customerio.track(receiver.id.to_s, "mailboxer_notification_email", notification_subject: message.subject.to_s)
    return CustomerioMailboxerNotificationMailer
  end

  def self.deliver
  end

end