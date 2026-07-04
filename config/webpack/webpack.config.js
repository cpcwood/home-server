// See the shakacode/shakapacker README and docs directory for advice on customizing your webpack config.

const path = require('path')
const { generateWebpackConfig } = require('shakapacker')

const erb = require('./loaders/erb')
const fonts = require('./loaders/fonts')

const webpackConfig = generateWebpackConfig()

// Allow Webpack to read erb and font files
webpackConfig.module.rules.unshift(erb)
webpackConfig.module.rules.unshift(fonts)

// resolve-url-loader must run before sass-loader; use dart sass as the implementation
webpackConfig.module.rules
  .filter(rule => rule.use && rule.use.some(e => (e.loader || '').includes('sass-loader')))
  .forEach(rule => {
    const sassIndex = rule.use.findIndex(e => (e.loader || '').includes('sass-loader'))
    rule.use.splice(sassIndex, 0, { loader: 'resolve-url-loader' })
    const sassLoader = rule.use[sassIndex + 1]
    sassLoader.options = {
      ...sassLoader.options,
      implementation: require('sass'),
      sassOptions: {
        ...(sassLoader.options && sassLoader.options.sassOptions),
        // Resolve bare `node_modules/...` imports (e.g. simplelightbox) under sass-loader 16's modern API
        loadPaths: [path.resolve(__dirname, '../..')]
      }
    }
  })

webpackConfig.performance = {
  maxEntrypointSize: 512000
}

module.exports = webpackConfig
