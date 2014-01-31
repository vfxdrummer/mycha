chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'
expect = chai.expect
require '../test_helper'
proxyquire = require 'proxyquire'



describe 'mycha.bin', ->
  beforeEach ->
    class MychaShim
      run: ->
    @MychaShim = sinon.spy(MychaShim)
    @simulate_mycha = (args...) =>
      mycha_bin = proxyquire '../../lib/mycha.bin', { './mycha': @MychaShim }
      mycha_bin args

  describe 'mycha run options', ->
    it 'Creates a new Mycha instance', ->
      @simulate_mycha 'run'
      expect(@MychaShim).to.have.been.calledOnce

    xit 'calls Mycha with the current working directory', ->
      @simulate_mycha 'run'
      expect(@MychaShim.args[0][0]).to.contain test_directory: process.cwd() + 'test'

    it 'sets mocha_arguments.watch=false if mycha run is called', ->
      @simulate_mycha 'run'
      expect(@MychaShim.args[0][0].mocha_arguments.watch).to.be.false

    it 'sets mocha_arguments.watch=true if mycha watch is called', ->
      @simulate_mycha 'watch'
      expect(@MychaShim.args[0][0].mocha_arguments.watch).to.be.true

    it 'sets reporter if passed', ->
      @simulate_mycha 'run', '--reporter', 'example_reporter'
      expect(@MychaShim.args[0][0].mocha_arguments.reporter).to.equal 'example_reporter'

    it 'sends mocha.options in a mocha object', ->
      @simulate_mycha 'run', '--mocha.foo', 'bar'
      expect(@MychaShim.args[0][0].mocha_arguments).to.contain foo: 'bar'
