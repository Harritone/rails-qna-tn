import consumer from '../channels/consumer';

$(document).on('turbolinks:load', function () {
  const answers = $('.answer');
  answers.each(function () {
    const answerId = $(this).data('answer-id');
    const comments = $(this).find('.answer-comments');
    if (comments.length > 0) {
      consumer.subscriptions.create(
        {
          channel: 'AnswersCommentsChannel',
          answer_id: answerId,
        },
        {
          connected: () => {},
          disconnected: () => {},
          received: (data) => {
            comments.append(data['comment']);
          },
          send_comment: function (comment, answer_id) {
            this.perform('send_comment', {
              comment: comment,
              answer_id: answer_id,
            });
          },
        },
      );
    }
    $(this)
      .find('#new_comment')
      .submit(function (e) {
        e.preventDefault();
        const textarea = $(this).find('#comment_content');
        const commentLength = $.trim(textarea.val()).length;
        if (commentLength > 5 && commentLength < 10000) {
          consumer.subscriptions.subscriptions[2].send_comment(
            textarea.val(),
            comments.data('answer-id'),
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
          $(this).prepend(errorDiv);
        }
        return false;
      });
  });
});
