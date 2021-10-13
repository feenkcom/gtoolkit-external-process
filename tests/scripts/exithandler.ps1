#
# Print to stdout progress of the script.
# This is used by GtExternalProcessExamples to test process termination.
#
echo "exithandler.ps1 starting"

$sleep=$args[0]
$acount=$args.Count

if ($acount -gt 0) {
    if ($sleep[0] -eq "-") {
        echo "The number of seconds must be positive"
        exit 1
    }
    echo "Sleeping $sleep seconds"
    sleep $sleep
}

# The test expects successful execution to emit both message
echo "exithandler.ps1 exiting"
echo "exithandler.ps1 quitting"
