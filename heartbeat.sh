#!/bin/sh

if curl 127.0.0.1:8080/.heartbeat; then
    echo Alive
    exit 0
else
    echo Dead
    exit 1
fi

				       
