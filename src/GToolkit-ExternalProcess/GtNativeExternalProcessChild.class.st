Class {
	#name : #GtNativeExternalProcessChild,
	#superclass : #GtBoxerValueBox,
	#instVars : [
		'pollDuration'
	],
	#classVars : [
		'SessionAnnouncer'
	],
	#category : #'GToolkit-ExternalProcess-External'
}

{ #category : #'library path' }
GtNativeExternalProcessChild class >> ffiLibraryName [
	^ GtExternalProcessLibrary
]

{ #category : #initialization }
GtNativeExternalProcessChild class >> initialize [ 
	"Get notified on session shutdown so registered processes can be terminated"

	SessionManager default 
		registerUserClassNamed: self name.

]

{ #category : #'private - ffi' }
GtNativeExternalProcessChild class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	^ self ffiCall: #(void process_child_drop(void** aHandle))
]

{ #category : #accessing }
GtNativeExternalProcessChild class >> sessionAnnouncer [

	^ SessionAnnouncer ifNil: [ SessionAnnouncer := Announcer new ]
]

{ #category : #'system startup & shutdown' }
GtNativeExternalProcessChild class >> shutDown: quitting [
	"Announce the shutdown.
	Registered processes will then terminate themselves (not a T-800)."

	quitting ifTrue:
		[ self sessionAnnouncer announce: GtExternalProcessShutdownAnnouncement new ].
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

{ #category : #initialization }
GtNativeExternalProcessChild >> initialize [

	super initialize.
	pollDuration := 50 milliSeconds.
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

{ #category : #private }
GtNativeExternalProcessChild >> quitImage [
	"The image is exiting, kill the process and flag polling to stop"

	^ self primKill
]

{ #category : #'system startup & shutdown' }
GtNativeExternalProcessChild >> terminateOnShutdown [
	"Register the receiver to be killed when Pharo exits"

	self class sessionAnnouncer weak 
		when: GtExternalProcessShutdownAnnouncement
		send: #quitImage
		to: self.
]

{ #category : #private }
GtNativeExternalProcessChild >> throttlePollDuration [
	"Progressively slow the poll duration to something over 500mS.
	This balances the desire to poll of short lived processes frequently and long lived processes rarely."

	pollDuration asNanoSeconds < 500000000 ifTrue:
		[ pollDuration := Duration nanoSeconds: 
			(pollDuration asNanoSeconds * 2 min: 500000000) ].
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

{ #category : #private }
GtNativeExternalProcessChild >> waitForExitDoing: aBlock [
	"Wait for the process to exit, evaluating the block every pollDuration seconds"

	[ pollDuration wait.
	self isTerminated ] whileFalse:
		[ aBlock cull: self.
		self throttlePollDuration ].
	"Catch anything that may have be written during the last wait"
	aBlock cull: self.
]

{ #category : #'api - process' }
GtNativeExternalProcessChild >> waitWithOutput [
	| anOutput |
	
	anOutput := GtNativeExternalProcessOutput fromNativeHandle: self primWaitWithOutput.
	self release.

	^ anOutput
]

{ #category : #testing }
GtNativeExternalProcessChild >> willTerminateOnShutdown [
	"Answer a boolean indicating whether the receiver will be killed on shutdown"

	^ self class sessionAnnouncer hasSubscriber: self
]
