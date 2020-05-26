module.exports = {
  test: /\.(woff(2)?|eot|otf|ttf)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
  use: {
    loader: 'file-loader',
    options: {
      name: '[name]-[contenthash].[ext]',
      outputPath: 'css/styles/fonts/',
      publicPath: (url) => `fonts/${url}`
    }
  }
}