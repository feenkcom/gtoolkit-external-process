Class {
	#name : #GtNativeExternalProcessChild,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-ExternalProcess-External'
}

{ #category : #'library path' }
GtNativeExternalProcessChild class >> ffiLibraryName [
	^ GtExternalProcessLibrary
]

{ #category : #'private - ffi' }
GtNativeExternalProcessChild class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	^ self ffiCall: #(void process_child_drop(void** aHandle))
]

{ #category : #'api - process' }
GtNativeExternalProcessChild >> asynchronousStderr [
	^ (GtNativeExternalAsynchronousStderr fromNativeHandle: (self primTakeAsynchronousStderr)) childProcess: self
]

{ #category : #'api - process' }
GtNativeExternalProcessChild >> asynchronousStdout [
	^ (GtNativeExternalAsynchronousStdout fromNativeHandle: (self primTakeAsynchronousStdout)) childProcess: self
]

{ #category : #'api - process' }
GtNativeExternalProcessChild >> id [
	^ self primId
]

{ #category : #testing }
GtNativeExternalProcessChild >> isTerminated [
	^ self primIsTerminated
]

{ #category : #'api - process' }
GtNativeExternalProcessChild >> kill [
	"Forces the child process to exit and return true if it was succesful. If the child has already exited, false is returned.
	This is equivalent to sending a SIGKILL on Unix platforms."
	<return: #Boolean>

	^ self primKill
]

{ #category : #'api - process' }
GtNativeExternalProcessChild >> kill: aSignalValue [
	"Forces the child process to exit by sending it a Unix Signal and return true if it was succesful.
	If the child has already exited, false is returned.
	Supported on Unix platforms, On Windows, falls back to #kill."
	<return: #Boolean>

	^ self primKillWithSignal: aSignalValue
]

{ #category : #'private - ffi' }
GtNativeExternalProcessChild >> primId [
	^ self ffiCall: #(uint32 process_child_id(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessChild >> primIsTerminated [
	^ self ffiCall: #(bool process_child_is_terminated(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessChild >> primKill [
	^ self ffiCall: #(bool process_child_kill(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessChild >> primKillWithSignal: aSignal [
	^ self ffiCall: #(bool process_child_kill_with_signal(self, int aSignal))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessChild >> primTakeAsynchronousStderr [
	^ self ffiCall: #(void* process_child_take_asynchronous_stderr(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessChild >> primTakeAsynchronousStdout [
	^ self ffiCall: #(void* process_child_take_asynchronous_stdout(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessChild >> primTryWait [
	^ self ffiCall: #(void* process_child_try_wait(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessChild >> primWait [
	^ self ffiCall: #(void* process_child_wait(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessChild >> primWaitWithOutput [
	^ self ffiCall: #(void* process_child_wait_with_output(self))
]

{ #category : #'api - process' }
GtNativeExternalProcessChild >> tryWait [
	| anExitStatusHandle |

	anExitStatusHandle := self primTryWait.
	^ anExitStatusHandle isNull
		ifTrue: [ nil ]
		ifFalse: [ GtNativeExternalProcessExitStatus fromNativeHandle: anExitStatusHandle ]
]

{ #category : #'api - process' }
GtNativeExternalProcessChild >> wait [
	<return: #GtNativeExternalProcessExitStatus>

	^ GtNativeExternalProcessExitStatus fromNativeHandle: self primWait
]

{ #category : #'api - process' }
GtNativeExternalProcessChild >> waitWithOutput [
	| anOutput |
	
	anOutput := GtNativeExternalProcessOutput fromNativeHandle: self primWaitWithOutput.
	self release.

	^ anOutput
]
