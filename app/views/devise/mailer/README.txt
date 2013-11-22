We are not using standard devise email templates.

Instead, we use transactional event support in customer.io
There is a custom Devise Mailer class in app/mailers, and it overrides each
email that devise would normally send to instead send an event to customer.io
along with data parameters that need to go into the email.

The emails are formatted and tracked within customerio web UI for the Stowaway account.