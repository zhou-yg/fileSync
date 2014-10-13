fs = require 'fs'
Node = require './jslibs/fileTree.js'

root = new Node [1,2,3]
n1 = new Node 'a'
n2 = new Node 'b'

root.push n1
root.push n2

do root.display