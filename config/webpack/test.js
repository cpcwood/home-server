process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

environment.config.set('devtool','none')

module.exports = environment.toWebpackConfig()
