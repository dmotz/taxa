// Generated by CoffeeScript 1.7.1

/*
 * Taxa
 * A tiny language inside JavaScript to enforce type signatures
 * 0.0.0
 * Dan Motzenbecker
 * http://oxism.com
 * Copyright 2014, MIT License
 */

(function() {
  var argSplit, ignore, ioSplit, k, key, libName, makeErr, optional, orSplit, parse, suffixRx, taxa, v, verify,
    __hasProp = {}.hasOwnProperty,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  libName = 'Taxa';

  key = {
    '0': 'null',
    a: 'array',
    b: 'boolean',
    f: 'function',
    n: 'number',
    o: 'object',
    s: 'string',
    u: 'undefined'
  };

  for (k in key) {
    if (!__hasProp.call(key, k)) continue;
    v = key[k];
    key[k.toUpperCase()] = v;
  }

  argSplit = ',';

  ioSplit = ' ';

  orSplit = '|';

  optional = '?';

  ignore = '_';

  suffixRx = /[^A-Z0-9]+$/i;

  taxa = function(sig, fn) {
    var i, o, s, shell, _ref;
    _ref = sig.split(ioSplit), i = _ref[0], o = _ref[1];
    i = (function() {
      var _i, _len, _ref1, _results;
      _ref1 = i.split(argSplit);
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        s = _ref1[_i];
        _results.push(parse(s));
      }
      return _results;
    })();
    o = parse(o);
    shell = function() {
      var def, n, result, _i, _len;
      for (n = _i = 0, _len = i.length; _i < _len; n = ++_i) {
        def = i[n];
        if (!verify(def, arguments[n])) {
          throw makeErr(def, arguments[n], n);
        }
      }
      result = fn.apply(this, arguments);
      if (!verify(o, result)) {
        throw makeErr(o, result);
      }
      return result;
    };
    for (k in fn) {
      v = fn[k];
      shell[k] = v;
    }
    shell.length = fn.length;
    shell.name = fn.name;
    shell.bind = function() {
      var a, _i, _len, _ref1;
      _ref1 = Array.prototype.slice.call(arguments, 1);
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        a = _ref1[_i];
        i.shift();
      }
      if (!i.length) {
        i.push([
          {
            ignore: true
          }
        ]);
      }
      return Function.prototype.bind.apply(shell, arguments);
    };
    return shell;
  };

  parse = function(sig) {
    var suffixes, type, types, _i, _len, _ref, _results;
    types = sig.split(orSplit);
    _results = [];
    for (_i = 0, _len = types.length; _i < _len; _i++) {
      type = types[_i];
      suffixes = ((_ref = type.match(suffixRx)) != null ? _ref[0] : void 0) || '';
      _results.push({
        type: key[type] || type,
        simple: !!key[type],
        ignore: type === ignore,
        optional: __indexOf.call(suffixes, optional) >= 0
      });
    }
    return _results;
  };

  verify = function(def, val) {
    var atom, _i, _len, _ref;
    for (_i = 0, _len = def.length; _i < _len; _i++) {
      atom = def[_i];
      if (atom.ignore) {
        return true;
      }
      if (atom.type === 'null' && val === null) {
        return true;
      }
      if (atom.simple && (atom.type === key.a && Array.isArray(val)) || (typeof val === atom.type) || (atom.optional && typeof val === key.u)) {
        return true;
      }
      if (!atom.simple && (val != null ? (_ref = val.constructor) != null ? _ref.name : void 0 : void 0) === atom.type) {
        return true;
      }
    }
    return false;
  };

  makeErr = function(def, val, n) {
    var _ref;
    return new Error("" + libName + ": Expected " + ((def.map(function(t) {
      return t.type;
    })).join(' or ')) + " as " + (n != null ? 'argument ' + n : 'return type') + ", given " + (def[0].simple ? typeof val : val != null ? (_ref = val.constructor) != null ? _ref.name : void 0 : void 0) + " " + (val !== void 0 ? '(' + val + ') ' : '') + "instead.");
  };

  taxa = taxa('s,f f', taxa);

  if ((typeof module !== "undefined" && module !== null ? module.exports : void 0) != null) {
    module.exports = taxa;
  } else {
    this.taxa = taxa;
  }

}).call(this);

//# sourceMappingURL=taxa.map