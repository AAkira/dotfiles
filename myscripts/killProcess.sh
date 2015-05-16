#!/bin/bash

# 実行時に指定された引数の数 $# の値が 3 でなければエラー終了。
if [ $# -ne 1 ]; then
	echo "指定された引数は$#個です。" 1>&2
	echo "実行するには1個の引数が必要です。" 1>&2
	exit 1
fi

kill -9 `ps auxw | grep $1 | egrep -v grep | egrep -v rotatelogs2 | grep Main | awk '{print $2}'`
