#!/usr/bin/env bash

wpid=$(cat .wpid)
[[ -n $wpid ]] && kill $wpid 2>/dev/null || echo no active waybar process
waybar >/dev/null & echo "$!" > .wpid
