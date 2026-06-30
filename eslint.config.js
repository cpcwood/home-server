const neostandard = require('neostandard')
const globals = require('globals')

module.exports = [
  {
    ignores: [
      '.vscode/',
      'bin/',
      'config/',
      'coverage/',
      'db/',
      'lib/',
      'log/',
      'public/',
      'shared/',
      'storage/',
      'tmp/',
      'vendor/'
    ]
  },
  ...neostandard(),
  {
    languageOptions: {
      sourceType: 'module',
      globals: {
        ...globals.browser,
        ...globals.node
      }
    }
  },
  {
    files: ['spec/**/*.js', '**/*_spec.js'],
    languageOptions: {
      globals: {
        ...globals.jest
      }
    }
  }
]
