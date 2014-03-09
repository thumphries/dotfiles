#!/bin/sh

/bin/bash -c "find . -Btime +7d -print0 | rm -rvf"