const sum = require('sum');
 
test('adds 1 + 2 + ruby constant to equal 13', () => {
  expect(sum(1, 2)).toBe(13);
});
