'use strict';

/**
 * hello router
 */

const {createCoreRouter} = require('@strapi/strapi').factories;

module.exports = createCoreRouter('api::hello.hello', {
  only: ['find', 'findOne', 'create'],
  config: {
    find: {
      auth: false,
    },
    findOne: {
      auth: false,
    },
    create: {
      auth: false,
    }
  }
});
