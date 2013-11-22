class CustomerioDeviseMailer < Devise::Mailer
  helper :application

  def confirmation_instructions(record, opts={})
    # rather than using the devise mailer just notify customer.io that the account was created.
    u = user_confirmation_url(confirmation_token: record.confirmation_token)
    $customerio.identify(id: record.id, email: record.email, created_at: record.created_at.to_i, name: record.name)
    $customerio.track(record.id, "account_confirmation_request", confirmation_url: u)
  end

  def unlock_instructions(record, opts={})
    u = user_unlock_url(:unlock_token => record.unlock_token)
    $customerio.identify(id: record.id, email: record.email, created_at: record.created_at.to_i, name: record.name)
    $customerio.track(record.id, "account_unlock_requested", unlock_url: u)
  end

  def reset_password_instructions(record, opts = {})
    u = edit_user_password_url(:reset_password_token => record.reset_password_token)
    $customerio.identify(id: record.id, email: record.email, created_at: record.created_at.to_i, name: record.name)
    $customerio.track(record.id, "password_reset_requested", edit_password_url: u)

  end
end