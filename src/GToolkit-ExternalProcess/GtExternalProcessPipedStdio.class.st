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
GtExternalProcessPipedStdio >> applyOnStdoutOf: aGtNativeExternalCommand [
	aGtNativeExternalCommand pipeStdout
]
