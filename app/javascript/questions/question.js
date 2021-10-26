$(document).on('turbolinks:load', function () {
  $('.edit-question-link').on('click', function (e) {
    e.preventDefault();
    $(this).hide();
    // const questionId = $(this).data('questionId');
    $(`form#edit-question`).removeClass('d-none');
  });
});
