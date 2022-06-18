#!/bin/sh

#
# Stopwatch
#
# Simple script to time how long things take. (useful for CI)
#
# Use it like this:
# > ./scripts/stopwatch.sh
# Started stopwatch..
# > echo "timed commands go here"
# > ./scripts/stopwatch.sh "install packages"
# Stopwatch: Completed interval "install packages" in 0m28s. (running total 0m28s)
# > echo "do some stuff"
# > ./scripts/stopwatch.sh lint
# Stopwatch: Completed interval "lint" in 0m13s. (running total 0m41s)
# > echo "do some stuff"
# > ./scripts/stopwatch.sh build
# Stopwatch: Completed interval "build" in 0m16s. (running total 0m57s)
# > sleep 10
# > ./scripts/stopwatch.sh test
# Stopwatch: Completed interval "test" in 0m28s. (running total 1m25s)
#

file_start=.stopwatch-start
file_prev=.stopwatch-prev

current_time=$(date +%s)

format() {
  ((m = ${1} / 60))
  ((s = ${1} % 60))
  printf "%0dm%02ds\n" "$m" "$s"
}

interval_name=$1

if test -f "$file_prev" && test -f "$file_start"; then
  read -r time_prev <$file_prev
  read -r time_start <$file_start
  if [[ "$time_start" == "" ]] || [[ "$time_prev" == "" ]]; then
    echo "unable to read start/prev times ('$time_start'/'$time_prev')"
    exit 1
  fi
  duration_total=$((current_time - time_start))
  duration_lap=$((current_time - time_prev))
  echo "Stopwatch: Completed interval \"$interval_name\" in $(format $duration_lap). (running total $(format $duration_total))"
else
  echo "Started stopwatch.."
  echo "$current_time" >$file_start
fi

echo "$current_time" >$file_prev
