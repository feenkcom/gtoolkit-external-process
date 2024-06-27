Class {
	#name : #GtNativeExternalProcessCommand,
	#superclass : #GtBoxerValueBox,
	#traits : 'TGtExternalProcessLibrary',
	#classTraits : 'TGtExternalProcessLibrary classTrait',
	#category : #'GToolkit-ExternalProcess-External'
}

{ #category : #'instance creation' }
GtNativeExternalProcessCommand class >> new: aCommandName [
	^ self ffiLibrary
		newString: aCommandName
		during: [ :aStringBox | self fromNativeHandle: (self primNewCommand: aStringBox) ]
]

{ #category : #'private -ffi' }
GtNativeExternalProcessCommand class >> primNewCommand: aStringBox [
	^ self ffiCall: #(void* process_command_new(GtStringBox aStringBox))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	^ self ffiCall: #(void process_command_drop(void* aHandle))
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> arg: anArgument [
	self ffiLibrary
		newString: anArgument
		during: [ :aStringBox | self primArg: aStringBox ]
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> clearEnv [
	self primClearEnv
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> output [
	^ GtNativeExternalProcessOutput fromNativeHandle: self primOutput
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand >> primArg: aStringBox [
	^ self ffiCall: #(void process_command_arg(self, GtStringBox aStringBox))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand >> primClearEnv [
	^ self ffiCall: #(void process_command_env_clear(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand >> primCurrentDirectory: aPathString [
	^ self ffiCall: #(void process_command_current_dir(self, GtStringBox aPathString))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand >> primOutput [
	^ self ffiCall: #(void* process_command_output(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand >> primRemoveEnvKey: aKeyString [
	^ self ffiCall: #(void process_command_env_remove(self, GtStringBox aKeyString))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand >> primSetEnvKey: aKeyString value: aValueString [
	^ self ffiCall: #(void process_command_env(
		self,
		GtStringBox aKeyString,
		GtStringBox aValueString))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand >> primSetStderr: anStdio [
	^ self ffiCall: #(void process_command_set_stderr(self, GtNativeExternalProcessStdio anStdio))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand >> primSetStdin: anStdio [
	^ self ffiCall: #(void process_command_set_stdin(self, GtNativeExternalProcessStdio anStdio))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessCommand >> primSetStdout: anStdio [
	^ self ffiCall: #(void process_command_set_stdout(self, GtNativeExternalProcessStdio anStdio))
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

	self ffiLibrary
		newString: aNameString
		during: [ :aStringBox | self primRemoveEnvKey: aStringBox ]
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> setEnv: aNameString value: aValueString [
	self
		assert: [ aNameString isString and: [ aNameString isSymbol not ] ]
		description: [ 'Env.var name must be a String but was {1}' format: { aNameString class name } ].

	self
		assert: [ aValueString isString and: [ aValueString isSymbol not ] ]
		description: [ 'Env.var value must be a String but was {1}' format: { aValueString class name } ].

	self ffiLibrary
		newString: aNameString
		during: [ :aKeyStringBox |
			self ffiLibrary
				newString: aValueString
				during: [ :aValueStringBox |
					self primSetEnvKey: aKeyStringBox value: aValueStringBox ] ]
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> spawn [
	| processChild |
	
	processChild := GtNativeExternalProcessChild fromNativeHandle: self primSpawn.
	(processChild isTerminated and: [ processChild tryWait isNil ])
		ifTrue: [ GtExternalProcessFailedToStart new 
			child: processChild;
			signal ].
	^ processChild
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> status [
	^ GtNativeExternalProcessExitStatus fromNativeHandle: self primStatus
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> stderr: aGtNativeExternalProcessStdio [
	self primSetStderr: aGtNativeExternalProcessStdio
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> stdin: aGtNativeExternalProcessStdio [
	self primSetStdin: aGtNativeExternalProcessStdio
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> stdout: aGtNativeExternalProcessStdio [
	self primSetStdout: aGtNativeExternalProcessStdio
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> windowsProcessCreationFlags: aNumber [
	"Sets the Windows specific process creation flags[1] to be passed to `CreateProcess`.
	See https://docs.microsoft.com/en-us/windows/win32/procthread/process-creation-flags"

	self primWindowsProcessCreationFlags: aNumber
]

{ #category : #'api - command' }
GtNativeExternalProcessCommand >> workingDirectory: aFileReference [
	self ffiLibrary
		newString: aFileReference fullName
		during: [ :aStringBox | self primCurrentDirectory: aStringBox ]
]
