Class {
	#name : #GtNativeExternalProcessCommand,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-ExternalProcess-External'
}

{ #category : #'library path' }
GtNativeExternalProcessCommand class >> ffiLibraryName [
	^ GtExternalProcessLibrary
]

{ #category : #'instance creation' }
GtNativeExternalProcessCommand class >> new: aCommandName [
	^ GtBoxerString
		fromString: aCommandName
		during: [ :aGtBoxerString | self fromNativeHandle: (self primNewCommand: aGtBoxerString) ]
]

{ #category : #'private -ffi' }
GtNativeExternalProcessCommand class >> primNewCommand: aGtBoxerString [
	^ self ffiCall: #(void* process_command_new(GtBoxerString aGtBoxerString))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	^ self ffiCall: #(void process_command_drop(void** aHandle))
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> arg: anArgument [
	GtBoxerString
		fromString: anArgument
		during: [ :aGtBoxerString | self primArg: aGtBoxerString ]
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> output [
	^ GtNativeExternalProcessOutput fromNativeHandle: self primOutput
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> pipeStderr [
	self primPipeStderr
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> pipeStdin [
	self primPipeStdin
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> pipeStdout [
	self primPipeStdout
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand >> primArg: aGtBoxerString [
	^ self ffiCall: #(void process_command_arg(self, GtBoxerString aGtBoxerString))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand >> primOutput [
	^ self ffiCall: #(void* process_command_output(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand >> primPipeStderr [
	^ self ffiCall: #(void process_command_pipe_stderr(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand >> primPipeStdin [
	^ self ffiCall: #(void process_command_pipe_stdin(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand >> primPipeStdout [
	^ self ffiCall: #(void process_command_pipe_stdout(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand >> primSpawn [
	^ self ffiCall: #(void* process_command_spawn(self))
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> spawn [
	^ GtNativeExternalProcessChild fromNativeHandle: self primSpawn
]
