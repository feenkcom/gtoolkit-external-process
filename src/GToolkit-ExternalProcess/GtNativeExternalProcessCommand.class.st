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
GtNativeExternalProcessCommand >> clearEnv [
	self primClearEnv
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> inheritStderr [
	self primInheritStderr
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> inheritStdin [
	self primInheritStdin
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> inheritStdout [
	self primInheritStdout
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
GtNativeExternalProcessCommand >> primClearEnv [
	^ self ffiCall: #(void process_command_env_clear(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand >> primCurrentDirectory: aPathString [
	^ self ffiCall: #(void process_command_current_dir(self, GtBoxerString aPathString))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand >> primInheritStderr [
	^ self ffiCall: #(void process_command_inherit_stderr(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand >> primInheritStdin [
	^ self ffiCall: #(void process_command_inherit_stdin(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand >> primInheritStdout [
	^ self ffiCall: #(void process_command_inherit_stdout(self))
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
GtNativeExternalProcessCommand >> primRemoveEnvKey: aGtBoxerStringKey [
	^ self ffiCall: #(void process_command_env_remove(self, GtBoxerString aGtBoxerStringKey))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand >> primSetEnvKey: aGtBoxerStringKey value: aGtBoxerStringValue [
	^ self ffiCall: #(void process_command_env(self, GtBoxerString aGtBoxerStringKey, GtBoxerString aGtBoxerStringValue))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand >> primSpawn [
	^ self ffiCall: #(void* process_command_spawn(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand >> primStatus [
	^ self ffiCall: #(void* process_command_status(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand >> primWindowsProcessCreationFlags: aNumber [
	^ self ffiCall: #(void process_windows_creation_flags(self, uint32 aNumber))
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> removeEnv: aNameString [
	self
		assert: [ aNameString isString and: [ aNameString isSymbol not ] ]
		description: [ 'Env.var name must be a String but was {1}' format: { aNameString class name } ].

	GtBoxerString
		fromString: aNameString
		during: [ :aGtBoxerStringKey | self primRemoveEnvKey: aGtBoxerStringKey ]
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> setEnv: aNameString value: aValueString [
	self
		assert: [ aNameString isString and: [ aNameString isSymbol not ] ]
		description: [ 'Env.var name must be a String but was {1}' format: { aNameString class name } ].
		
	self
		assert: [ aValueString isString and: [ aValueString isSymbol not ] ]
		description: [ 'Env.var value must be a String but was {1}' format: { aValueString class name } ].

	GtBoxerString
		fromString: aNameString
		during: [ :aGtBoxerStringKey | 
			GtBoxerString
				fromString: aValueString
				during: [ :aGtBoxerStringValue | 
					self primSetEnvKey: aGtBoxerStringKey value: aGtBoxerStringValue ] ]
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> spawn [
	^ GtNativeExternalProcessChild fromNativeHandle: self primSpawn
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> status [
	^ GtNativeExternalProcessExitStatus fromNativeHandle: self primStatus
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> windowsProcessCreationFlags: aNumber [
	"Sets the Windows specific process creation flags[1] to be passed to `CreateProcess`.
	See https://docs.microsoft.com/en-us/windows/win32/procthread/process-creation-flags"

	self primWindowsProcessCreationFlags: aNumber
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> workingDirectory: aFileReference [
	GtBoxerString
		fromString: aFileReference fullName
		during: [ :aBoxerString | self primCurrentDirectory: aBoxerString ]
]
