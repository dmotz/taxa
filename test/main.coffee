require 'should'
require 'coffee-script/register'
t = require '../taxa.coffee'

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
      t('_ n', sayHello).should.throw()


    it 'should allow optional arguments', ->
      t('s? b', -> true).should.not.throw()


    it 'should throw when optional types do not match', ->
      (-> t('s? b', -> true) 5).should.throw()


    it 'should allow functions that return no value', ->
      (-> t('s _', ->) 'hi').should.not.throw()
      (-> t('s u', ->) 'hi').should.not.throw()


    it 'should allow functions that accept no arguments', ->
      t('_ b', -> true).should.not.throw()


    it 'should allow functions that accept no arguments and return no value', ->
      t('_ _', ->).should.not.throw()


    it 'should correctly identify arrays passed as arguments', ->
      fn = t 'a a', (a) -> []
      (-> fn [1, 2, 3]).should.not.throw()
      (-> fn {}).should.throw()


    it 'should allow disjunctive types for arguments', ->
      fn = t 's|n,n b', (x, l) -> String(x).length >= l
      (-> fn 123, 3).should.not.throw()
      (-> fn '123', 3).should.not.throw()


    it 'should allow disjunctive types for return signatures', ->
      fn = t 's s|b', (s) ->
        if s is 'true'
          true
        else if s is 'false'
          false
        else
          s

      fn('true').should.equal true
      fn('false').should.equal false
      fn('neither').should.equal 'neither'


    it 'should differentiate null from undefined', ->
      takesNull = t '0 _', ->
      (-> takesNull null).should.not.throw()
      takesNull.should.throw()
      t('_ 0', ->).should.throw()
      (-> t('U _', ->) null).should.throw()


    it 'should enforce complex types', ->
      bufferMaker = t 'n Buffer', (n) -> new Buffer n
      (-> bufferMaker 1).should.not.throw()
      takesBuffer = t 'Buffer _', ->
      (-> takesBuffer bufferMaker 1).should.not.throw()
      (-> takesBuffer 1).should.throw()


  describe '#.bind()', ->

    it 'should allow partial application with type checking', ->
      add3 = t('n,n n', add).bind @, 3
      add3(2).should.equal 5


    it 'should allow partial application of all expected arguments', ->
      add3And4 = t('n,n n', add).bind @, 3, 4
      add3And4().should.equal 7


  describe '#taxa.disable()', ->

    it 'should disable type checking', ->
      t.disable()
      t('_ n', sayHello)().should.equal 'hello'


  describe '#taxa.enable()', ->

    it 'should enable type checking', ->
      t.enable()
      t('_ n', sayHello).should.throw()


  describe '#taxa.addAlias()', ->

    it 'should allow aliasing other types with abbreviations', ->
      t.addAlias 'i8', 'Int8Array'
      (-> t('i8 i8', (a) -> a) new Int8Array).should.not.throw()


    it 'should disallow alias collisions', ->
      (-> t.addAlias 'i8', 'UInt8Array').should.throw()

