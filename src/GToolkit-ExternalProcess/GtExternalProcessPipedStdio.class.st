"
#Piped stdio
A new pipe should be arranged to connect the parent and child processes.

Writing more than a pipe buffer's worth of input to stdin without also reading stdout and stderr at the same time may cause a deadlock. This is an issue when running any program that doesn't guarantee that it reads its entire stdin before writing more than a pipe buffer's worth of output. The size of a pipe buffer varies on different targets.

Nothing echoed to console:
{{gtExample:GtExternalProcessExamples>>pipedHelloWorld}}
"
Class {
	#name : #GtExternalProcessPipedStdio,
	#superclass : #GtExternalProcessStdio,
	#category : #'GToolkit-ExternalProcess-Core'
}

{ #category : #dispatch }
GtExternalProcessPipedStdio >> applyOnStderrOf: aGtNativeExternalCommand [
	aGtNativeExternalCommand pipeStderr
]

{ #category : #dispatch }
GtExternalProcessPipedStdio >> applyOnStdinOf: aGtNativeExternalCommand [
	aGtNativeExternalCommand pipeStdin
]

{ #category : #dispatch }
GtExternalProcessPipedStdio >> applyOnStdoutOf: aGtNativeExternalCommand [
	aGtNativeExternalCommand pipeStdout
]
