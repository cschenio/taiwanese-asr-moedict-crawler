#!/bin/bash

curl -O -s 'https://raw.githubusercontent.com/g0v/moedict-webkit/master/t/index.json'
curl -O -s 'https://raw.githubusercontent.com/g0v/moedict-webkit/master/t/xref.json'

ruby crawler.rb index.json xref.json parsed.json
