Class {
	#name : #GtNativeExternalProcessStdio,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-ExternalProcess-External'
}

{ #category : #accessing }
GtNativeExternalProcessStdio class >> ffiLibrary [
	^ GtExternalProcessLibrary
]

{ #category : #'private - ffi' }
GtNativeExternalProcessStdio class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void process_stdio_drop(void* aHandle))
]
