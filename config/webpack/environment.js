const { environment } = require('@rails/webpacker')

// resolve-url-loader must be used before sass-loader
environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader'
});

// Allow Webpack to read erb files
const erb = require('./loaders/erb')
environment.loaders.prepend('erb', erb)

// Allow Webpack to read font files
const fonts = require('./loaders/fonts')
environment.loaders.prepend('fonts', fonts)

// Get the actual sass-loader config and set loader to dart sass
const sassLoader = environment.loaders.get('sass')
const sassLoaderConfig = sassLoader.use.find( e => e.loader == 'sass-loader' )
sassLoaderConfig.options.implementation = require('sass')

module.exports = environment
