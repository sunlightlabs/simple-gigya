fs = require 'fs'
jsp = require("uglify-js").parser
pro = require("uglify-js").uglify

{print} = require 'util'
{spawn} = require 'child_process'

settings = require('./settings.coffee').settings

build = (callback) ->
    unless settings.ICON_BASE_URL and settings.GIGYA_KEY
        throw 'No settings found. Make sure you supply ICON_BASE_URL and GIGYA_KEY'
    coffee = spawn 'coffee', ['-c', '-o', 'lib', 'src']
    coffee.stderr.on 'data', (data) ->
        process.stderr.write data.toString()
    coffee.stdout.on 'data', (data) ->
        print data.toString()
    coffee.on 'exit', (code) ->
        callback()? if code is 0

apply_settings_and_minify = () ->
    js =''
    fs.readFile './lib/gigya.js', (err, data) ->
        js = data.toString().replace('{% settings.ICON_BASE_URL %}', settings.ICON_BASE_URL)
                            .replace('{% settings.GIGYA_KEY %}', settings.GIGYA_KEY)
        fs.writeFile('./lib/gigya.js', js, (err) -> )
        ast = jsp.parse(js)
        ast = pro.ast_mangle(ast)
        ast = pro.ast_squeeze(ast)
        fs.writeFile('./lib/gigya.min.js', pro.gen_code(ast), (err) -> )

task 'build', 'Build .js and .min.js files with your keys', ->
    build(apply_settings_and_minify)
    print 'Built files: ./lib/gigya.js, ./lib/gigya.min.js'
    print "\n"
