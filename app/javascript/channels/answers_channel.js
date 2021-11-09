import consumer from './consumer';

consumer.subscriptions.create(
  {
    channel: 'AnswersChannel',
    question_id: gon.question_id,
  },
  {
    connected() {
      console.log('answerschannel');
      this.perform('follow');
    },

    received(data) {
      // console.log(data);
      const answersList = document.getElementById('answers');
      const div = document.createElement('div');
      div.innerHTML = data;
      answersList.appendChild(div.firstChild);
    },
  },
);
