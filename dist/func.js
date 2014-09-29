// Generated by LiveScript 1.2.0
'use strict';
var isType, cloneArray, apply, curry, chain, tryCatch, out$ = typeof exports != 'undefined' && exports || this, slice$ = [].slice;
isType = require('./prelude').isType;
cloneArray = function(xs){
  var i$, len$, x, results$ = [];
  for (i$ = 0, len$ = xs.length; i$ < len$; ++i$) {
    x = xs[i$];
    results$.push(x);
  }
  return results$;
};
function applyNoContext(f, args){
  switch (args.length) {
  case 0:
    return f();
  case 1:
    return f(args[0]);
  case 2:
    return f(args[0], args[1]);
  case 3:
    return f(args[0], args[1], args[2]);
  case 4:
    return f(args[0], args[1], args[2], args[3]);
  case 5:
    return f(args[0], args[1], args[2], args[3], args[4]);
  case 6:
    return f(args[0], args[1], args[2], args[3], args[4], args[5]);
  case 7:
    return f(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
  case 8:
    return f(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
  case 9:
    return f(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
  default:
    return f.apply(void 8, args);
  }
}
function applyWithContext(context, f, args){
  switch (args.length) {
  case 0:
    return f.call(context);
  case 1:
    return f.call(context, args[0]);
  case 2:
    return f.call(context, args[0], args[1]);
  case 3:
    return f.call(context, args[0], args[1], args[2]);
  case 4:
    return f.call(context, args[0], args[1], args[2], args[3]);
  case 5:
    return f.call(context, args[0], args[1], args[2], args[3], args[4]);
  case 6:
    return f.call(context, args[0], args[1], args[2], args[3], args[4], args[5]);
  case 7:
    return f.call(context, args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
  case 8:
    return f.call(context, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
  case 9:
    return f.call(context, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
  default:
    return f.apply(context, args);
  }
}
out$.apply = apply = function(f, args, context){
  if (context != null) {
    return applyWithContext(context, f, args);
  } else {
    return applyNoContext(f, args);
  }
};
out$.curry = curry = function(n, fn){
  var _curry;
  if (typeof n === 'function') {
    fn = n;
    n = fn.length;
  }
  _curry = function(args){
    if (!(n > 1)) {
      return fn;
    } else {
      return function(){
        var params;
        params = cloneArray(args);
        if (params.push.apply(params, arguments) < n) {
          return _curry(params);
        } else {
          return applyNoContext(fn, params);
        }
      };
    }
  };
  return _curry([]);
};
out$.chain = chain = function(){
  var i$, fns, cb, link, e;
  fns = 0 < (i$ = arguments.length - 1) ? slice$.call(arguments, 0, i$) : (i$ = 0, []), cb = arguments[i$];
  link = function(e){
    var args;
    args = slice$.call(arguments, 1);
    if (e || fns.length === 0) {
      cb.apply(null, arguments);
    } else {
      try {
        applyNoContext(fns.shift(), args.concat(link));
      } catch (e$) {
        e = e$;
        cb(e);
      }
    }
  };
  try {
    fns.shift()(link);
  } catch (e$) {
    e = e$;
    cb(e);
  }
};
out$.tryCatch = tryCatch = function(fn, cb){
  var err, res, e;
  err = null;
  res = null;
  try {
    res = fn();
  } catch (e$) {
    e = e$;
    err = e instanceof Error
      ? e
      : new Error(e);
  }
  if (cb) {
    cb(err, res);
  }
  err || res;
};