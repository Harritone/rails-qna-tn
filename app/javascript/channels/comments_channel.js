import consumer from './consumer';

consumer.subscriptions.create(
  {
    channel: 'CommentsChannel',
    question_id: gon.question_id,
  },
  {
    connected() {
      console.log('comment conected');
      this.perform('follow');
    },
    received(data) {
      console.log(data);
      let textarea;
      const wrapper = document.createElement('div');
      const { commentable_type, commentable_id } = data.comment;
      let parentElement;
      if (commentable_type === 'Question') {
        textarea = document.getElementById('comment_content');
        parentElement = document.getElementById('question-comments');
      } else {
        textarea = document.querySelector(
          `#answer-${commentable_id}-comments-wrapper #comment_content`,
        );
        parentElement = document.getElementById(
          `answer-${commentable_id}-comments`,
        );
      }
      wrapper.innerHTML = data.element;
      parentElement.appendChild(wrapper.firstChild);
      textarea.value = '';
    },
  },
);
