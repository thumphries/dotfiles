#!/bin/sh -exu

# Set faster mouse tracking speed - GUI max is 3.0
defaults write -g com.apple.mouse.scaling 5.0

# Set a blazing fast repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0
