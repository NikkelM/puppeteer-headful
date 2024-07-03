#!/bin/sh

Xvfb -ac :99 -screen 0 1280x1024x16 &
# Xvfb -ac :99 -screen 0 1280x1024x16 > /dev/null 2>&1 &

XVFB_PID=$!

# Wait a brief moment to ensure Xvfb starts
sleep 2

# Check if Xvfb is running by checking if the PID exists
if ! kill -0 $XVFB_PID > /dev/null 2>&1; then
    echo "Xvfb failed to start"
    exit 1
else
    echo "Xvfb started successfully"
fi

export DISPLAY=:99.0
export PUPPETEER_EXEC_PATH="$(which google-chrome-stable)"

echo PUPPETEER_EXEC_PATH=$PUPPETEER_EXEC_PATH

cmd=$@
echo "Running '$cmd'!"
if $cmd; then
    echo "Successfully ran '$cmd'"
else
    exit_code=$?
    echo "Failure running '$cmd', exited with $exit_code"
    exit $exit_code
fi
