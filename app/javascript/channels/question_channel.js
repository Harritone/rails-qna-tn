import consumer from './consumer';

consumer.subscriptions.create(
  {
    channel: 'QuestionChannel',
  },
  {
    connected() {
      console.log('Connected');
      // this.perform('echo', { phrase: 'Hello there!' });
      this.perform('follow');
    },

    received(data) {
      console.log(data);
      const questionsList = document.getElementById('questions-list');
      const div = document.createElement('div');
      div.innerHTML = data;
      questionsList.appendChild(div.firstChild);
    },
  },
);
