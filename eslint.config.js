const eslintConfigPrettier = require('eslint-config-prettier')
const babelParser = require('@babel/eslint-parser')
const globals = require('globals')
// const standard = require('eslint-config-standard')

module.exports = [
  {
    languageOptions: {
      globals: {
        ...globals.browser,
        ...globals.node
      },
      parserOptions: {
        ecmaVersion: 11,
        sourceType: 'module'
      },
      parser: babelParser
    },
    rules: {
      'max-len': [
        'error',
        {
          code: 100,
          tabWidth: 2,
          ignoreComments: true,
          ignoreUrls: true,
          ignoreStrings: true,
          ignoreTemplateLiterals: true
        }
      ]
    }
  },
  // standard,
  eslintConfigPrettier
]
