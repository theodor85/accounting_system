// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import 'materialize-css/dist/js/materialize'
import Vue from 'vue';

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import "controllers"
import { createVueApp } from '../src/vue_helper';

window.createVueApp = createVueApp;


// register vue components
const requireComponents = require.context(
  '../src/components',
  true,
);

Vue.component('fields-table', requireComponents('./FieldsTable.vue').default);
// console.log('asd  ');
