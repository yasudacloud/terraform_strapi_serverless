const serverless = require("serverless-http");
const Strapi = require("@strapi/strapi/lib/index.js");

const startStrapi = async (strapi) => {
  try {
    if (!strapi.isLoaded) {
      await strapi.load();
    }
    await strapi.postListen();
    strapi.server.mount();
    return strapi;
  } catch (error) {
    return strapi.stopWithError(error);
  }
};

exports.handler = async (event, context) => {
  let workingDir = process.cwd();
  if (process.env.LAMBDA_TASK_ROOT) {
    workingDir = process.env.LAMBDA_TASK_ROOT;
  }
  if (!global.strapi) {
    Strapi({dir: workingDir});
  }
  if (!global.strapi.isLoaded) {
    await startStrapi(global.strapi);
  }
  const handler = serverless(global.strapi.server.app);
  return handler(event, context);
};
