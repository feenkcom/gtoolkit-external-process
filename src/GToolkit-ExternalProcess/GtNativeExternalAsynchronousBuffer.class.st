Class {
	#name : #GtNativeExternalAsynchronousBuffer,
	#superclass : #GtNativeExternalProcessChildStdio,
	#instVars : [
		'childProcess'
	],
	#category : #'GToolkit-ExternalProcess-External'
}

{ #category : #'private - ffi' }
GtNativeExternalAsynchronousBuffer class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	^ self ffiCall: #(void process_async_buffer_drop(void* aHandle))
]

{ #category : #initialization }
GtNativeExternalAsynchronousBuffer >> childProcess: anObject [

	childProcess := anObject
]

{ #category : #testing }
GtNativeExternalAsynchronousBuffer >> isEndOfStreamReached [
	^ self primIsEndOfStreamReached
]

{ #category : #'api - buffer' }
GtNativeExternalAsynchronousBuffer >> pollBytes [
	^ self ffiLibrary
		newArrayU8FromHandle: self primPollBytes
		during: [ :aGtBoxerArray | aGtBoxerArray asByteArray ]
]

{ #category : #'api - buffer' }
GtNativeExternalAsynchronousBuffer >> pollString [
	^ self ffiLibrary
		newStringFromHandle: self primPollString
		during: [ :aGtBoxerString | aGtBoxerString string ]
]

{ #category : #'api - buffer' }
GtNativeExternalAsynchronousBuffer >> pollStringEvery: aDuration do: aBlock [
	^ [ 
		| shouldStop |
		
		shouldStop := false.
		[ shouldStop ] whileFalse: [
			| aPolledString |

			aPolledString := self pollString.
			aPolledString 
				ifEmpty: [
					childProcess isTerminated
						ifTrue: [ shouldStop := true ] ]
				ifNotEmpty: [ :aString | 
					aBlock value: aString ].
			aDuration wait ].
	] fork
]

{ #category : #'api - buffer' }
GtNativeExternalAsynchronousBuffer >> pollStringUpTo: anAmount [
	^ self ffiLibrary
		newStringFromHandle: (self primPollStringUpTo: anAmount)
		during: [ :aGtBoxerString | aGtBoxerString string ]
]

{ #category : #'private - ffi' }
GtNativeExternalAsynchronousBuffer >> primIsEndOfStreamReached [
	^ self ffiCall: #(bool process_async_buffer_is_end_of_file_reached(self))
]

{ #category : #'private - ffi' }
GtNativeExternalAsynchronousBuffer >> primPollBytes [
	^ self ffiCall: #(void* process_async_buffer_poll(self))
]

{ #category : #'private - ffi' }
GtNativeExternalAsynchronousBuffer >> primPollString [
	^ self ffiCall: #(void* process_async_buffer_poll_string(self))
]

{ #category : #'private - ffi' }
GtNativeExternalAsynchronousBuffer >> primPollStringUpTo: anAmount [
	^ self ffiCall: #(void* process_async_buffer_poll_string_up_to(self, size_t anAmount))
]

{ #category : #'private - ffi' }
GtNativeExternalAsynchronousBuffer >> primReleaseSignaller [
	^ self ffiCall: #(void process_async_buffer_release_signaller(self))
]

{ #category : #'api - buffer' }
GtNativeExternalAsynchronousBuffer >> releaseSemaphoreSignaller [
	self primReleaseSignaller
]
