#!/bin/bash
files=$(git diff --cached --name-only | grep '\.jsx\?$')
scssFiles=$(git diff --cached --name-only | grep '\.scss\?$')

if [[ $files = "" ]] ; then
 if [[ $scssFiles = "" ]] ; then
  exit 0
 fi
fi
 
result=0
for file in ${files}; do
 out=`./node_modules/.bin/eslint $file`
 if [[ $out != "" ]] ; then
 result=1
 echo "$out"
 fi
done;

scssResult=0
for scssFile in ${scssFiles}; do
 out=`./node_modules/.bin/stylelint $scssFile`
 if [[ $out != "" ]] ; then
 scssResult=1
 echo "$out"
 fi
done;
 
if [[ $result != 0 ]] ; then
 if [[ $scssResult != 0 ]] ; then
  echo "ESLint and StyleLint both check failed, commit denied"
  exit 1
 else
  echo "Eslint check failed, commit denied"
  exit 1
 fi
else
 if [[ $scssResult != 0 ]] ; then
  echo "StyleLint check failed, commit denied"
  exit 1
 else
  echo "Success"
  exit 0
 fi
fi
