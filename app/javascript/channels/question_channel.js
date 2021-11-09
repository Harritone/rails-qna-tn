import consumer from './consumer';

consumer.subscriptions.create(
  {
    channel: 'QuestionChannel',
  },
  {
    connected() {
      this.perform('follow');
    },

    received(data) {
      const questionsList = document.getElementById('questions-list');
      const div = document.createElement('div');
      div.innerHTML = data;
      questionsList.appendChild(div.firstChild);
    },
  },
);
