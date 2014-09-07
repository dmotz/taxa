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



