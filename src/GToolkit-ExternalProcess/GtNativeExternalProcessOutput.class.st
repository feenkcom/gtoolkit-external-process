Class {
	#name : #GtNativeExternalProcessOutput,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-ExternalProcess-External'
}

{ #category : #'library path' }
GtNativeExternalProcessOutput class >> ffiLibraryName [
	^ GtExternalProcessLibrary
]

{ #category : #'private - ffi' }
GtNativeExternalProcessOutput class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	^ self ffiCall: #(void process_output_drop(void** aHandle))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessOutput >> primtGetStderr [
	^ self ffiCall: #(void* process_output_stderr(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessOutput >> primtGetStderrString [
	^ self ffiCall: #(void* process_output_stderr_string(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessOutput >> primtGetStdout [
	^ self ffiCall: #(void* process_output_stdout(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessOutput >> primtGetStdoutString [
	^ self ffiCall: #(void* process_output_stdout_string(self))
]

{ #category : #accessing }
GtNativeExternalProcessOutput >> stderr [
	<return: #String>

	^ self stderrString
]

{ #category : #accessing }
GtNativeExternalProcessOutput >> stderrBytes [
	<return: #ByteArray>

	^ GtBoxerArrayU8
		fromNativeHandle: self primtGetStderr
		during: [ :anArrayU8 | anArrayU8 asByteArray ]
]

{ #category : #accessing }
GtNativeExternalProcessOutput >> stderrString [
	<return: #String>

	^ GtBoxerString
		fromNativeHandle: self primtGetStderrString
		during: [ :aBoxerString | aBoxerString string ]
]

{ #category : #accessing }
GtNativeExternalProcessOutput >> stdout [
	<return: #String>

	^ self stdoutString
]

{ #category : #accessing }
GtNativeExternalProcessOutput >> stdoutBytes [
	<return: #ByteArray>

	^ GtBoxerArrayU8
		fromNativeHandle: self primtGetStdout
		during: [ :anArrayU8 | anArrayU8 asByteArray ]
]

{ #category : #accessing }
GtNativeExternalProcessOutput >> stdoutString [
	<return: #String>

	^ GtBoxerString
		fromNativeHandle: self primtGetStdoutString
		during: [ :aBoxerString | aBoxerString string ]
]
