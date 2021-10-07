Class {
	#name : #GtExternalProcessPipedStdio,
	#superclass : #GtExternalProcessStdio,
	#category : #'GToolkit-ExternalProcess-Core'
}

{ #category : #dispatch }
GtExternalProcessPipedStdio >> applyOnStdoutOf: aGtNativeExternalCommand [
	aGtNativeExternalCommand pipeStdout
]
