#!/usr/bin/env bash

wpid=$(cat .wpid)
[[ -n $wpid ]] && kill $wpid
waybar >/dev/null & echo "$!" > .wpid
