#usr/bin/env bash

g++ $1 -I/usr/local/include -L/usr/local/lib -lavformat -lavfilter -lavutil -lavcodec -lswscale 
