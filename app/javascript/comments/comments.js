import consumer from '../channels/consumer';

$(document).on('turbolinks:load', function () {
  const comments = $('#question-comments');
  if (comments.length > 0) {
    consumer.subscriptions.create(
      {
        channel: 'QuestionsCommentsChannel',
        question_id: comments.data('question-id'),
      },
      {
        connected: () => {},
        disconnected: () => {},
        received: (data) => {
          comments.append(data['comment']);
        },
        send_comment: function (comment, question_id) {
          console.log(question_id);
          this.perform('send_comment', {
            comment: comment,
            question_id: question_id,
          });
        },
      },
    );
  }
  $('#new_comment').submit((e) => {
    e.preventDefault();
    const form = $('#new_comment');
    const textarea = $('#new_comment').find('#comment_content');
    const commentLength = $.trim(textarea.val()).length;
    if (commentLength > 5 && commentLength < 10000) {
      consumer.subscriptions.subscriptions[1].send_comment(
        textarea.val(),
        comments.data('question-id'),
      );
      textarea.val('');
    } else {
      const errorDiv = document.createElement('div');
      errorDiv.innerHTML = `
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
          <strong>Holy guacamole!</strong> Your comment should be as long as 10 000 characters and more than 5.
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
      `;
      form.prepend(errorDiv);
    }
    return false;
  });
});
