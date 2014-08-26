require 'should'
t = require '../taxa'

goodName = (name) -> name.length > 3
add      = (a, b) -> a + b
sayHello = -> 'hello'


describe 'taxa', ->

  describe '#taxa()', ->

    it 'should always return a function', ->

      (typeof t 's b', goodName).should.equal 'function'


    it 'should throw an error unless a signature string and a function are passed', ->

      t.should.throw()
      (-> t 1, 2).should.throw()


    it 'should return a function that behaves as the original', ->
      fn = t 's b', goodName
      fn('Dan').should.equal false
      fn('Danny').should.equal true


    it 'should accept capitalized variants in the type signature', ->
      fn = t 'S B', goodName
      fn('Dan').should.equal false
      fn('Danny').should.equal true


    it 'should throw an error if passed the wrong type of arguments', ->
      (-> t('n,n n', add) 'hi').should.throw()


    it 'should throw an error if the function returns the wrong type', ->
      (-> t('_ n', sayHello)()).should.throw()


    it 'should allow optional arguments', ->
      t('s? b', -> true).should.not.throw()


    it 'should allow functions that return no value', ->
      (-> t('s _', ->) 'hi').should.not.throw()


    it 'should allow functions that accept no arguments', ->
      t('_ b', -> true).should.not.throw()


    it 'should allow functions that accept no arguments and return no value', ->
      t('_ _', ->).should.not.throw()


    it 'should correctly identify arrays passed as arguments', ->
      fn = t 'a a', (a) -> []
      (-> fn [1, 2, 3]).should.not.throw()
      (-> fn {}).should.throw()

