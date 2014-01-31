chai = require 'chai'
path = require 'path'
sinon = require 'sinon'
chai.use require 'sinon-chai'
expect = chai.expect
require '../test_helper'
proxyquire = require 'proxyquire'

describe 'run method', ->

  beforeEach ->
    @child_spawn_stub = sinon.stub().returns
      stdout: pipe: ->
      stderr: pipe: ->
      on: ->
    @Mycha = proxyquire '../../lib/mycha', child_process: spawn: @child_spawn_stub


  it 'spawns mocha as a child process', ->
    mycha = new @Mycha
    mycha.run()
    mocha_path = path.resolve __dirname, '../../node_modules/mocha/bin/mocha'
    expect(@child_spawn_stub).to.have.been.calledOnce
    expect(@child_spawn_stub.args[0][0]).to.equal mocha_path


  it 'sends --watch flag to mocha if watch option is true', ->
    mycha = new @Mycha mocha_arguments: watch: true
    mycha.run()
    expect(@child_spawn_stub.args[0][1].join ' ').to.contain '--watch'


  it 'passes reporter option to mocha', ->
    mycha = new @Mycha mocha_arguments: reporter: 'example_reporter'
    mycha.run()
    expect(@child_spawn_stub.args[0][1].join ' ').to.contain '--reporter example_reporter'
