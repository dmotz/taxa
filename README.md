# Taxa
### A tiny runtime type grammar for JavaScript and CoffeeScript
[Dan Motzenbecker](http://oxism.com), MIT License

[@dcmotz](http://twitter.com/dcmotz)


```coffeescript
add = t 'n,n n', (a, b) -> a + b
add 3, 7
# => 10
add '3', '7'
# => Taxa: Expected number as argument 0, given string (3) instead.
```

## Brief

Taxa is a small metaprogramming experiment that introduces a minimal grammar for
type annotations to JavaScript (and by extension, CoffeeScript).

Unlike other projects of this nature, Taxa is purely a runtime type checker
rather than a static analyzer. When a Taxa-wrapped function receives or returns
arguments of the wrong type, an exception is thrown.

Further unlike other type declaration projects for JavaScript, Taxa's DSL lives
purely within the syntax of the language. There is no intermediary layer and no
preprocessing is required.


## Grammar

Taxa type signatures are intended to be quick to type and to occupy few additional
columns in your code.

Following this spirit of brevity, examples are also shown in CoffeeScript as it's
a natural fit to Taxa's style.

In the following, Taxa is aliased as `t` (though `$` or `taxa` feel natural as well):

```coffeescript
t = require 'taxa'
# or in a browser without a module loader:
t = window.taxa
```

```javascript
var t = require('taxa');
// or in a browser without a module loader:
var t = window.taxa;
```

A type signature is composed of two halves: the argument types and the return
type, separated by a space.

```coffeescript
pluralize = t 'String String', (word) -> word + 's'
```

```javascript
var pluralize = t('String String', function(word) {
  return word + 's';
});
```

The above signature indicates a function that expects a single string argument
and is expected to return a string as a result. If any other types are passed to
it, an informative error will be thrown:

```coffeescript
pluralize 7
# => Taxa: Expected string as argument 0, given number (7) instead.
```

```javascript
pluralize(7);
// => Taxa: Expected string as argument 0, given number (7) instead.
```


### Shorthand

Taxa provides a shorthand for built-in types, indicated by their first letter.
The following is equivalent to the previous example:

```coffeescript
exclaim = t 's s', (word) -> word + '!'
```

```javascript
var exclaim = t('s s', function(word) {
  return word + '!';
});
```

Capital letter shorthand works as well:

```coffeescript
exclaim = t 'S S', (word) -> word + '!'
```

```javascript
var exclaim = t('S S', function(word) {
  return word + '!';
});
```

The shorthand mapping is natural, with the exception of `null`:

- `0 => null`
- `a => array`
- `b => boolean`
- `f => function`
- `n => number`
- `o => object`
- `s => string`
- `u => undefined`

Multiple arguments are separated by commas:

```coffeescipt
add = t 'n,n n', (a, b) -> a + b
```

```javascript
var add = t('n,n n', function(a, b) {
  return a + b;
});
```

The above function is expected to take two numbers as arguments and return a third.


### Ignores

Occasionally you may want to ignore type checking on a particular argument.
Use the `_` character to mark it as ignored in the signature. For example, you may
have a method that produces effects without returning a value:

```coffeescript
Population::setCount = t 'n _', (@count) ->
```

```javascript
Population.prototype.setCount = t('n _', function(count) {
  this.count = count;
});
```

Or a function that computes a result without input:
```coffeescript
t '_ n', -> Math.PI / 2
```

```javascript
t('_ n', function() {
  return Math.PI / 2;
});
```

### Optionals

Similarly you can specify arguments as optional and their type will only be
checked if a value is present:

```coffeescript
t 's,n? n', (string, radix = 10) -> parseInt string, radix
```

```javascript
t('s,n? n', function(string, radix) {
  if (radix == null) {
    radix = 10;
  }
  return parseInt(string, radix);
});
```

### Ors

For polymorphic functions that accept different types of arguments, you can use
the `|` character to separate types.

```coffeescript
combine = t 'n|s,n|s n|s', (a, b) -> a + b
```

```javascript
var combine = t('n|s,n|s n|s', function(a, b) {
  return a + b;
});
```

For each argument and return type in the above function, either a number or a
string is accepted.


