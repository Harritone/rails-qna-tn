import consumer from './consumer';

consumer.subscriptions.create(
  {
    channel: 'AnswersChannel',
    question_id: gon.question_id,
  },
  {
    connected() {
      this.perform('follow');
    },

    received(data) {
      const answersList = document.getElementById('answers');
      const div = document.createElement('div');
      div.innerHTML = data;
      answersList.appendChild(div.firstChild);
    },
  },
);
