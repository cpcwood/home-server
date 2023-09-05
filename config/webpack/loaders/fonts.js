module.exports = {
  test: /\.(woff(2)?|eot|otf|ttf)$/,
  use: {
    loader: 'file-loader',
    options: {
      name: '[name]-[contenthash].[ext]',
      outputPath: 'css/fonts/',
      publicPath: (url) => `fonts/${url}`
    }
  }
}
