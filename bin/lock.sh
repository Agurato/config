#!/bin/bash
scrot /tmp/screen.png
convert /tmp/screen.png -scale 5% -scale 2000% /tmp/screen.png

image_src=/home/agurato/Images/key.png
image_desc=$(identify $image_src | grep -o '[0-9][0-9]*x[0-9][0-9]* ')
image_width=0
image_height=0

while IFS='x' read -ra ADDR; do
	image_width="${ADDR[0]}"
	image_height="${ADDR[1]}"
done <<< "$image_desc"

monitors=$(xrandr --query | grep ' connected' | grep -o '[0-9][0-9]*x[0-9][0-9]*[^ ]*')

while read -r line; do
	monitor_size=""
	monitor_width=0
	monitor_height=0
	monitor_x=0
	monitor_y=0
	x=0
	y=0
	while IFS='+' read -ra info; do
		monitor_size="${info[0]}"
		monitor_x="${info[1]}"
		monitor_y="${info[2]}"
	done <<< "$line"

	while IFS='x' read -ra mon_size; do
        	monitor_width="${mon_size[0]}"
        	monitor_height="${mon_size[1]}"
	done <<< "$monitor_size"

	x=$(($monitor_x + $monitor_width / 2 - $image_width / 2))
	y=$(($monitor_y + $monitor_height / 2 - $image_height / 2))

	convert /tmp/screen.png $image_src -geometry +$x+$y -composite -matte /tmp/screen.png
done <<< "$monitors"

i3lock -u -i /tmp/screen.png
rm /tmp/screen.png
