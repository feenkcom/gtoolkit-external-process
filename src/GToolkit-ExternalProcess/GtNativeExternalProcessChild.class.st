Class {
	#name : #GtNativeExternalProcessChild,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-ExternalProcess-External'
}

{ #category : #'library path' }
GtNativeExternalProcessChild class >> ffiLibraryName [
	^ GtExternalProcessLibrary
]

{ #category : #'private - ffi' }
GtNativeExternalProcessChild class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	^ self ffiCall: #(void process_child_drop(void** aHandle))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessChild >> primWaitWithOutput [
	^ self ffiCall: #(void* process_child_wait_with_output(self))
]

{ #category : #'api - process' }
GtNativeExternalProcessChild >> waitWithOutput [
	| anOutput |
	
	anOutput := GtNatoveExternalProcessOutput fromNativeHandle: self primWaitWithOutput.
	self release.

	^ anOutput
]
