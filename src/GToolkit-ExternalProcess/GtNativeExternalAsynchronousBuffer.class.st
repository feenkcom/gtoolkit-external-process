Class {
	#name : #GtNativeExternalAsynchronousBuffer,
	#superclass : #GtBoxerValueBox,
	#instVars : [
		'childProcess'
	],
	#category : #'GToolkit-ExternalProcess-External'
}

{ #category : #'library path' }
GtNativeExternalAsynchronousBuffer class >> ffiLibraryName [
	^ GtExternalProcessLibrary
]

{ #category : #'private - ffi' }
GtNativeExternalAsynchronousBuffer class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	^ self ffiCall: #(void process_async_buffer_drop(void** aHandle))
]

{ #category : #initialization }
GtNativeExternalAsynchronousBuffer >> childProcess: anObject [

	childProcess := anObject
]

{ #category : #'api - buffer' }
GtNativeExternalAsynchronousBuffer >> pollString [
	^ GtBoxerString
		fromNativeHandle: self primPollString
		during: [ :aGtBoxerString | aGtBoxerString string ]
]

{ #category : #'private - ffi' }
GtNativeExternalAsynchronousBuffer >> primPollString [
	^ self ffiCall: #(void* process_async_buffer_poll_string(self))
]
