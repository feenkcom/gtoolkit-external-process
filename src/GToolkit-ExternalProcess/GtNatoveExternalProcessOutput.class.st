Class {
	#name : #GtNatoveExternalProcessOutput,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-ExternalProcess-External'
}

{ #category : #'library path' }
GtNatoveExternalProcessOutput class >> ffiLibraryName [
	^ GtExternalProcessLibrary
]

{ #category : #'private - ffi' }
GtNatoveExternalProcessOutput class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	^ self ffiCall: #(void process_output_drop(void** aHandle))
]

{ #category : #'private - ffi' }
GtNatoveExternalProcessOutput >> primtGetStderr [
	^ self ffiCall: #(void* process_output_stderr(self))
]

{ #category : #'private - ffi' }
GtNatoveExternalProcessOutput >> primtGetStderrString [
	^ self ffiCall: #(void* process_output_stderr_string(self))
]

{ #category : #'private - ffi' }
GtNatoveExternalProcessOutput >> primtGetStdout [
	^ self ffiCall: #(void* process_output_stdout(self))
]

{ #category : #'private - ffi' }
GtNatoveExternalProcessOutput >> primtGetStdoutString [
	^ self ffiCall: #(void* process_output_stdout_string(self))
]

{ #category : #accessing }
GtNatoveExternalProcessOutput >> stderr [
	^ GtBoxerArrayU8 fromNativeHandle: self primtGetStderr
]

{ #category : #accessing }
GtNatoveExternalProcessOutput >> stderrString [
	^ (GtBoxerString fromNativeHandle: self primtGetStderrString) string
]

{ #category : #accessing }
GtNatoveExternalProcessOutput >> stdout [
	^ GtBoxerArrayU8 fromNativeHandle: self primtGetStdout
]

{ #category : #accessing }
GtNatoveExternalProcessOutput >> stdoutString [
	^ (GtBoxerString fromNativeHandle: self primtGetStdoutString) string
]
