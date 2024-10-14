Class {
	#name : #GtNativeExternalProcessAsyncOutput,
	#superclass : #GtBoxerValueBox,
	#traits : 'TGtExternalProcessLibrary',
	#classTraits : 'TGtExternalProcessLibrary classTrait',
	#category : #'GToolkit-ExternalProcess-External'
}

{ #category : #'private - ffi' }
GtNativeExternalProcessAsyncOutput class >> primRelease: aHandle [
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	^ self ffiCall: #(void process_async_output_drop(void* aHandle))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessAsyncOutput >> primTakeOutput [
	self ffiCall: #(void* process_async_output_take_output(self))
]

{ #category : #accessing }
GtNativeExternalProcessAsyncOutput >> takeOutput [
	^ GtNativeExternalProcessOutput fromNativeHandle: self primTakeOutput
]

{ #category : #accessing }
GtNativeExternalProcessAsyncOutput >> tryTakeOutput [
	| aHandle |
	
	aHandle := self primTakeOutput.
	^ aHandle isNull
		ifTrue: [ nil ]
		ifFalse: [ GtNativeExternalProcessOutput fromNativeHandle: aHandle ]
]
