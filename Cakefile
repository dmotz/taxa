cp     = require 'child_process'
coffee = './node_modules/.bin/coffee'


task 'build', 'compile .coffee to .js', ->
  cp.exec coffee + ' -mc taxa.coffee', (err, stdout, stderr) ->
    throw err if err
    console.log stdout, stderr


task 'watch',   'compile continuously', ->
  watcher = cp.spawn coffee, ['-mwc', 'taxa.coffee']
  watcher.stdout.pipe process.stdout
  watcher.stderr.pipe process.stderr
