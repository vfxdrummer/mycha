chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'
expect = chai.expect
require './test_helper'
proxyquire = require 'proxyquire'



describe 'integration tests', ->
  beforeEach ->
    class MychaShim
      run: ->
    @MychaShim = sinon.spy(MychaShim)
    @simulate_mycha = (args...) =>
      mycha_bin = proxyquire '../lib/mycha.bin', { './mycha': @MychaShim }
      mycha_bin args

  describe 'mycha run', ->
    it 'Creates a new Mycha instance', ->
      @simulate_mycha 'run'
      expect(@MychaShim).to.have.been.calledOnce

    it 'calls Mycha with the current working directory', ->
      @simulate_mycha 'run'
      expect(@MychaShim.args[0][0]).to.have.equal process.cwd()

    describe 'mycha options', ->
      it 'sets watch=false if mycha run is called', ->
        @simulate_mycha 'run'
        expect(@MychaShim.args[0][1].watch).to.be.false

      it 'sets watch=true if mycha watch is called', ->
        @simulate_mycha 'watch'
        expect(@MychaShim.args[0][1].watch).to.be.true

      it 'sets reporter if passed', ->
        @simulate_mycha 'run', '--reporter', 'example_reporter'
        expect(@MychaShim.args[0][1].reporter).to.equal 'example_reporter'

      it 'sends mocha.options in a mocha object', ->
        @simulate_mycha 'run', '--mocha.foo', 'bar'
        expect(@MychaShim.args[0][1].mocha).to.eql foo: 'bar'
