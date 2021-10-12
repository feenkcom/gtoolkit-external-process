#!/bin/bash
#
# Print to stdout an indication of whether the scripts exit handler has been 
# called or not.
#
# This is useful for testing the behaviour of SIGKILL vs. SIGTERM.
#

trap exit_handler EXIT
trap hang_up HUP
trap usr_one USR1

function exit_handler()
{
	echo "$0 exiting"
}

function hang_up()
{
	echo "$0 hangup"
}

function usr_one()
{
	echo "$0 usr_one"
}
echo "$0 starting"

if [ ! -z "$1" ]
then
	sleep $1
fi

echo "$0 quitting"
exit 0
