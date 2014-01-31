Mocha = require 'mocha'
child = require 'child_process'
path = require 'path'
_ = require 'underscore'
TestsFinder = require './tests_finder'


class Mycha

  # The default options to use.
  # These options can be overridden by the user using command-line arguments.
  @default_options =
    test_directory: path.join process.cwd(), 'test'
    mocha_arguments:
      compilers: 'coffee:coffee-script'
      reporter: 'spec'
      colors: true


  constructor: (user_options={}) ->
    # The options to use by this instance.
    @options = @_calculate_final_options user_options


  # Determines the options to be used by Mycha.
  #
  # * user provided options
  # * default options
  _calculate_final_options: (user_options) ->
    # Merge user and default options.
    _(user_options).defaults Mycha.default_options


  _convert_to_command_line_args: (options) ->
    args = []
    for argument_name, argument_value of options
      return if argument_value is false
      args.push "--#{argument_name}"
      args.push argument_value if argument_value isnt true
    args


  # Return an array of arguments to be passed to mocha.
  _get_mocha_command_line_args: ->
    mocha_command_line_args = @_convert_to_command_line_args @options.mocha_arguments

    # Include mycha test helper
    mocha_command_line_args.push path.join __dirname, '/helper.coffee'

    # Include files found in /test
    mocha_command_line_args.concat new TestsFinder(@options.test_directory).files()


  run: (callback) ->
    mocha_path = path.resolve __dirname, '../node_modules/mocha/bin/mocha'
    childProcess = child.spawn mocha_path, @_get_mocha_command_line_args()
    childProcess.stdout.pipe process.stdout
    childProcess.stderr.pipe process.stderr
    childProcess.on 'exit', callback if callback



module.exports = Mycha
