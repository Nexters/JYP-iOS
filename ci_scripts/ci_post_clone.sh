#!/bin/sh

cd ..

curl -Ls https://install.tuist.io|bash

tuist fetch 

tuist generate