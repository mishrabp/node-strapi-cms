module.exports = ({ env }) => ({
    upload: {
      provider: 'azure-storage',
      providerOptions: {
        account: 'terraformsabibhu2021',
        accountKey: 'rIp0HPqdEoQNrg6rlazVJwwTyNKL02rHm1dK8R0GIYn7rt3CVr/+nNjWnwu+/nkhm2HT6L9vXzn59+6tImTXMA==',
        containerName: 'strapicms',
        defaultPath: 'assets',
        maxConcurrent: 10
      }
    }
  });


/*
module.exports = ({ env }) => ({
    upload: {
      provider: 'azure-storage',
      providerOptions: {
        account: env('STORAGE_ACCOUNT'),
        accountKey: env('STORAGE_ACCOUNT_KEY'),
        serviceBaseURL: env('STORAGE_URL'),
        containerName: env('STORAGE_CONTAINER_NAME'),
        cdnBaseURL: env('STORAGE_CDN_URL'),
        defaultPath: 'assets',
        maxConcurrent: 10
      }
    }
  });
*/