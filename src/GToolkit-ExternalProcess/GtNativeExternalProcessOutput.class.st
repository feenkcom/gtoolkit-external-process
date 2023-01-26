Class {
	#name : #GtNativeExternalProcessOutput,
	#superclass : #GtBoxerValueBox,
	#traits : 'TGtExternalProcessLibrary',
	#classTraits : 'TGtExternalProcessLibrary classTrait',
	#category : #'GToolkit-ExternalProcess-External'
}

{ #category : #'private - ffi' }
GtNativeExternalProcessOutput class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	^ self ffiCall: #(void process_output_drop(void* aHandle))
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
	
	^ self ffiLibrary
		newArrayU8FromHandle: self primtGetStderr
		during: [ :anArrayU8 | anArrayU8 asByteArray ]
]

{ #category : #accessing }
GtNativeExternalProcessOutput >> stderrString [
	<return: #String>
	
	^ self ffiLibrary
		newStringFromHandle: self primtGetStderrString
		during: [ :aStringBox | aStringBox string ]
]

{ #category : #accessing }
GtNativeExternalProcessOutput >> stdout [
	<return: #String>

	^ self stdoutString
]

{ #category : #accessing }
GtNativeExternalProcessOutput >> stdoutBytes [
	<return: #ByteArray>

	^ self ffiLibrary
		newArrayU8FromHandle: self primtGetStdout
		during: [ :anArrayU8 | anArrayU8 asByteArray ]
]

{ #category : #accessing }
GtNativeExternalProcessOutput >> stdoutString [
	<return: #String>

	^ self ffiLibrary
		newStringFromHandle: self primtGetStdoutString
		during: [ :aStringBox | aStringBox string ]
]
