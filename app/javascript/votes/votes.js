$(document).on('turbolinks:load', function () {
  $('.vote-up, .vote-down, .revote').on('ajax:success', function (e) {
    const voteData = e.detail[0];
    const resource =
      voteData.resource === 'question'
        ? $('.question')
        : $(`#answer-${voteData.id}`);

    resource.find('.vote-up, .vote-down').toggle();
    resource.find('.revote').toggle();
    resource.find('.total-votes').html(voteData.votes);
  });
});
