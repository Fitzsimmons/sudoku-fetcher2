#!/bin/bash

set -euo pipefail

mkdir -p build

docker run -v `pwd`:`pwd` -w `pwd` lambci/lambda:build-ruby2.5 bundle install --deployment
zip -r build/sudoku_fetcher2.zip sudoku_fetcher2.rb vendor
