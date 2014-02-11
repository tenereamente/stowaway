class CustomerioMailboxerNotificationMailer
  def send_email(message, receiver)
    binding.pry
    subject = message.subject.to_s
    $customerio.identify(id: receiver.id, email: receiver.email, created_at: receiver.created_at.to_i, name: receiver.name)
    $customerio.track(receiver.id, "mailboxer_notification_email", subject: subject)
  end
end