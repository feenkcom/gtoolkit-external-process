Class {
	#name : #GtNativeExternalProcessChildStdoutStdio,
	#superclass : #GtNativeExternalProcessStdio,
	#category : #'GToolkit-ExternalProcess-External'
}

{ #category : #'instance creation' }
GtNativeExternalProcessChildStdoutStdio class >> fromChildStdout: aChildStdout during: aBlock [
	^ self
		fromNativeHandle: (self primCreateFromChildStdout: aChildStdout)
		during: aBlock
]

{ #category : #'private - ffi' }
GtNativeExternalProcessChildStdoutStdio class >> primCreateFromChildStdout: aChildStdout [
	^ self ffiCall: #(void* process_stdio_from_child_stdout(void* aChildStdout))
]
