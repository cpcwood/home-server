process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

environment.config.set('devtool','eval-cheap-source-map')

module.exports = environment.toWebpackConfig()
