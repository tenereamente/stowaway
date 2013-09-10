$ ->
  $('#list-space-step1').on 'ajax:success', (event, data, status, xhr) ->
    console.log(data)
    # TODO: once the data being sent back is a form partial
    # that is correctly prefilled, advance the wizard to highlight the next
    # stage, update the button, and replace the content of the form with
    # the next stage.
    # $('#invitationModal').foundation('reveal', 'close')
    # $('#request-invitation-button').hide()
    