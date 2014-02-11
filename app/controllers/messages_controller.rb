# This file based on rails-messaging gem: https://github.com/frodefi/rails-messaging
# it was published with the following license:
=begin
Copyright 2011 YOURNAME

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
=end

class MessagesController < ApplicationController
  def index
    @box = params[:box] || 'inbox'
    @messages = current_user.mailbox.inbox if @box == 'inbox'
    @messages = current_user.mailbox.sentbox if @box == 'sent'
    @messages = current_user.mailbox.trash if @box == 'trash'
    @inbox_thread_count = current_user.mailbox.inbox.count
    @sent_thread_count = current_user.mailbox.sentbox.count
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(params.require(:message).permit(:conversation_id, :body, :subject).merge(sender: current_user))

    if @message.conversation_id
      @conversation = Conversation.find(@message.conversation_id)
      unless @conversation.is_participant?(current_user)
        flash[:alert] = "You do not have permission to view that conversation."
        return redirect_to root_path
      end
      receipt = current_user.reply_to_conversation(@conversation, @message.body, nil, true, true, @message.attachment)
    else
      unless @message.valid?
        return render :new
      end
      @recipient = User.find(params.require(:message)[:recipient])
      receipt = current_user.send_message(@recipient, @message.body, @message.subject, true, @message.attachment)
    end
    flash[:notice] = "Message sent."

    redirect_to message_path(receipt.conversation)
  end

  def show
    @conversation = Conversation.find_by_id(params[:id])
    unless @conversation.is_participant?(current_user)
      flash[:alert] = "You do not have permission to view that conversation."
      return redirect_to root_path
    end
    @message = Message.new conversation_id: @conversation.id
    current_user.mark_as_read(@conversation)
  end

  def trash
    conversation = Conversation.find_by_id(params[:id])
    if conversation
      current_user.trash(conversation)
      flash[:notice] = "Message sent to trash."
    else
      conversations = Conversation.find(params[:conversations])
      conversations.each { |c| current_user.trash(c) }
      flash[:notice] = "Messages sent to trash."
    end
    redirect_to messages_path(box: params[:current_box])
  end

  def untrash
    conversation = Conversation.find(params[:id])
    current_user.untrash(conversation)
    flash[:notice] = "Message untrashed."
    redirect_to messages_path(box: 'inbox')
  end

  def search
    @search = params[:search]
    @messages = current_user.search_messages(@search)
    render :index
  end

end