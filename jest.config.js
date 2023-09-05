module.exports = {
  testRegex: '.*_spec.js',
  roots: ['<rootDir>', '<rootDir>/spec/javascript'],
  moduleFileExtensions: ['js', 'js.erb', 'erb'],
  moduleDirectories: ['node_modules', '<rootDir>/app/frontend/packs'],
  moduleNameMapper: {
    '\\.(jpg|jpeg|png|gif|eot|otf|webp|svg|ttf|woff|woff2|mp4|webm|wav|mp3|m4a|aac|oga)$':
      '<rootDir>/spec/javascript/__mocks__/fileMock.js',
    '\\.(css|less)$': '<rootDir>/spec/javascript/__mocks__/styleMock.js'
  },
  transform: {
    '^.+\\.js$': 'babel-jest',
    '^.+\\.erb$': [
      'jest-erb-transformer',
      {
        application: 'rails',
        timeout: 20000,
        babelConfig: true
      }
    ]
  }
}
