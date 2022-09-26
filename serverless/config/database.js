const path = require('path');

module.exports = ({env}) => ({
  connection: {
    client: 'sqlite',
    connection: {
      // Set the EFS mount path
      // filename: path.join(__dirname, '..', env('DATABASE_FILENAME', '.tmp/data.db')),
      filename: '/mnt/efs/hello.db'
    },
    useNullAsDefault: true,
  },
});
