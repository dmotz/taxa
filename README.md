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

