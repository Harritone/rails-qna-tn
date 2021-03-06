// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from '@rails/ujs';
import Turbolinks from 'turbolinks';
require('stylesheets/application.scss');
import * as ActiveStorage from '@rails/activestorage';
import 'bootstrap/dist/js/bootstrap';
import 'bootstrap/dist/css/bootstrap';
import 'channels';
import '@nathanvda/cocoon';
import '@fortawesome/fontawesome-free/css/all';
import '../answers/answers';
import '../questions/question';
import '../votes/votes';
// import '../comments/questionsComments';
// import '../comments/answersComments';

Rails.start();
Turbolinks.start();
ActiveStorage.start();
