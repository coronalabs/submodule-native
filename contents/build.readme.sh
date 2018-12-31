#!/bin/bash

path=`dirname $0`
pushd $path > /dev/null

pandoc -f markdown -t html -o README.html README.markdown --section-divs --css .style.css 

popd
