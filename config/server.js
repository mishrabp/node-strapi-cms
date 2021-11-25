module.exports = ({ env }) => ({
  host: env('HOST', '0.0.0.0'),
  port: env.int('PORT', 8081),
  admin: {
    auth: {
      secret: env('ADMIN_JWT_SECRET', '761d01afb55eef054ec73c5e95f71187'),
    },
  },
});
