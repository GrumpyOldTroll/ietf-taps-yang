#!/bin/bash

input_yang=$1

if [ ! -f "$input_yang" ] ; then
  echo "no file $input_yang"
  echo "usage: $0 <input>.yang :"
  echo "  runs yanglint on all files named negative-<input>-*.json,"
  echo "  with <input>.yang, and confirms that they all fail."
  exit 1
fi

yangfile=$(basename -- "$input_yang")
# extension="${yangfile##*.}"
input="${yangfile%.*}"

problems=0
problems_in=""
passed=""
passed_count=0

for f in $(ls negative-${input}-*.json); do
  bash -x -e -c "yanglint -f json -t data -D -s -V -p modules -p . $input.yang $f" 2>&1 | grep -v "warn: Module's revisions are not unique (2018-06-28)" > tmp-negative.out

  if [ "${PIPESTATUS[0]}" = "0" ]; then
    problems=$((problems+1))
    problems_in="$problems_in\\n  $f"
  else
    filename=$(basename -- "$f")
    # extension="${filename##*.}"
    basename="${filename%.*}"
    if [ ! -e $basename.expect ]; then
      echo "no such file: $basename.expect"
      problems=$((problems+1))
      problems_in="$problems_in\\n  $f"
    else
      if ! bash -x -c "diff $basename.expect tmp-negative.out"; then
        problems=$((problems+1))
        problems_in="$problems_in\\n  $f"
      else
        passed="$passed\\n  $f"
        passed_count=$((passed_count+1))
      fi
    fi
  fi
done

if [ "$problems" != "0" ]; then
  printf "$problems negative tests had problems:"
  printf "$problems_in\\n"
  exit 1
else
  printf "all $passed_count negative tests passed:"
  printf "$passed\\n"
fi
