// See the shakacode/shakapacker README and docs directory for advice on customizing your webpackConfig.

const { webpackConfig } = require('shakapacker')

// Allow Webpack to read erb files
const erb = require('./loaders/erb')
webpackConfig.module.rules.unshift(erb)

// Allow Webpack to read font files
const fonts = require('./loaders/fonts')
webpackConfig.module.rules.unshift(fonts)

// resolve-url-loader must be used before sass-loader
webpackConfig.module.rules.find(rule => rule.test.test('.sass')).use.splice(-1, 0, {
  loader: 'resolve-url-loader'
})

// Get the actual sass-loader config and set loader to dart sass
const sassLoader = webpackConfig.module.rules.find(rule => rule.test.test('.sass'))
const sassLoaderConfig = sassLoader.use.find( e => e.loader && e.loader.includes('sass-loader'))
sassLoaderConfig.options.implementation = require('sass')

module.exports = webpackConfig
