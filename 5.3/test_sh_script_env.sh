#!/bin/sh

echo "Digite o ano:"
read YEAR;


export YEAR
export MONTH=10
export TITLE="This is a title"

ncl myscript_env.ncl