module.exports = {
  test: /\.(woff(2)?|eot|otf|ttf)$/,
  type: 'asset/resource',
  generator: {
    filename: 'css/fonts/[name]-[hash][ext]'
  }
}
