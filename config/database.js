module.exports = ({ env }) => ({
  defaultConnection: 'default',
  connections: {
    default: {
      connector: 'mongoose',
      settings: {
        host: env('DATABASE_HOST', 'devopsmasterlinuxvm.centralus.cloudapp.azure.com'),
        srv: env.bool('DATABASE_SRV', false),
        port: env.int('DATABASE_PORT', 9003),
        database: env('DATABASE_NAME', 'strapicms'),
        username: env('DATABASE_USERNAME', 'mongoadmin'),
        password: env('DATABASE_PASSWORD', 'passw0rd!'),
      },
      options: {
        authenticationDatabase: env('AUTHENTICATION_DATABASE', null),
        ssl: env.bool('DATABASE_SSL', false),
      },
    },
  },
});
