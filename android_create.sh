#!/bin/sh

name=$1

android create project \
--target 1 \
--name $1 \
--path ./$1 \
--activity $1Activity \
--package com.xingyue.$1
