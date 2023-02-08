Class {
	#name : #GtNativeExternalProcessChildStdin,
	#superclass : #GtNativeExternalProcessChildStdio,
	#category : #'GToolkit-ExternalProcess-External'
}

{ #category : #'private - ffi' }
GtNativeExternalProcessChildStdin class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	self ffiCall: #(void process_child_stdin_drop(void* aHandle))
]

{ #category : #streaming }
GtNativeExternalProcessChildStdin >> close [
	self primClose.
	self release
]

{ #category : #streaming }
GtNativeExternalProcessChildStdin >> cr [
	self nextPut: Character cr
]

{ #category : #streaming }
GtNativeExternalProcessChildStdin >> crlf [
	self nextPutAll: String crlf
]

{ #category : #streaming }
GtNativeExternalProcessChildStdin >> lf [
	self nextPut: Character lf
]

{ #category : #streaming }
GtNativeExternalProcessChildStdin >> nextPut: aCharacter [
	"Write a given character to the stdin"

	^ self nextPutAll: aCharacter asString
]

{ #category : #streaming }
GtNativeExternalProcessChildStdin >> nextPutAll: aString [
	"Write a given string to the stdin"

	^ self ffiLibrary
		newString: aString
		during: [ :aStringBox | self primWriteString: aStringBox ]
]

{ #category : #'private - ffi' }
GtNativeExternalProcessChildStdin >> primClose [
	^ self ffiCall: #(void process_child_stdin_close(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessChildStdin >> primWriteString: aStringBox [
	^ self ffiCall: #(void process_child_stdin_write_string(self, GtStringBox aStringBox))
]
