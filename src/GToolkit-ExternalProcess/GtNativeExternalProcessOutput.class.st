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
	^ GtBoxerArrayU8 fromNativeHandle: self primtGetStderr
]

{ #category : #accessing }
GtNativeExternalProcessOutput >> stderrString [
	^ (GtBoxerString fromNativeHandle: self primtGetStderrString) string
]

{ #category : #accessing }
GtNativeExternalProcessOutput >> stdout [
	^ GtBoxerArrayU8 fromNativeHandle: self primtGetStdout
]

{ #category : #accessing }
GtNativeExternalProcessOutput >> stdoutString [
	^ (GtBoxerString fromNativeHandle: self primtGetStdoutString) string
]
