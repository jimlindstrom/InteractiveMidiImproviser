#!/bin/bash

wget -O toc.html 'http://www.contemplator.com/war.html'

for i in `grep href toc.html  | grep "<li>" | sed -e 's/^[^"]*"//' | sed -e 's/".*//' | sed -e 's/^/www.contemplator.com\//'`; do 
wget -O /tmp/jbl $i
wget `grep '\.mid' /tmp/jbl | sed -e 's/[^"]*"\.\.//' | sed -e 's/".*//' | sed -e 's/^/www.contemplator.com/'`
done

