Class {
	#name : #GtNativeExternalProcessChild,
	#superclass : #GtBoxerValueBox,
	#traits : 'TGtExternalProcessLibrary',
	#classTraits : 'TGtExternalProcessLibrary classTrait',
	#instVars : [
		'pollDuration',
		'mutex',
		'stdin'
	],
	#classVars : [
		'SessionAnnouncer'
	],
	#category : #'GToolkit-ExternalProcess-External'
}

{ #category : #initialization }
GtNativeExternalProcessChild class >> initialize [ 
	"Get notified on session shutdown so registered processes can be terminated"

	SessionManager default 
		registerUserClassNamed: self name.

]

{ #category : #'private - ffi' }
GtNativeExternalProcessChild class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	^ self ffiCall: #(void process_child_drop(void* aHandle))
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

{ #category : #accessing }
GtNativeExternalProcessChild class >> startUp: isNewSession [
	"Overriden to prevent ExternalObject>>#startUp: from being executed twice"
]

{ #category : #'api - stdio' }
GtNativeExternalProcessChild >> asynchronousStderr [
	^ (GtNativeExternalAsynchronousStderr fromNativeHandle: (self primTakeAsynchronousStderr)) childProcess: self
]

{ #category : #'api - stdio' }
GtNativeExternalProcessChild >> asynchronousStdout [
	^ (GtNativeExternalAsynchronousStdout fromNativeHandle: (self primTakeAsynchronousStdout)) childProcess: self
]

{ #category : #ui }
GtNativeExternalProcessChild >> gtSummaryFor: aView [
	<gtView>

	^ aView columnedList
		  title: 'Summary';
		  priority: 10;
		  items: [ self summaryAttributes ];
		  column: #Attribute text: [ :item | item first ];
		  column: #Value text: [ :item | item second ];
		  send: [ :item | item third ];
		  actionUpdateButton
]

{ #category : #'api - process' }
GtNativeExternalProcessChild >> id [
	^ self primId
]

{ #category : #initialization }
GtNativeExternalProcessChild >> initialize [
	super initialize.
	
	mutex := Mutex new
]

{ #category : #testing }
GtNativeExternalProcessChild >> isRunning [

	^ self isTerminated not
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
	| result |

	result := self primKill.
	"Read the process exit status, otherwise a defunct process will be left behind"
	"The wait is never returning occasionally on linux, to be investigated"
	"self primWait."
	^ result.
]

{ #category : #'private - ffi' }
GtNativeExternalProcessChild >> primAsyncWaitWithOutputSignaller: aSemaphoreSignaller semaphoreIndex: aSemaphoreIndex [
	^ self ffiCall: #(void* process_child_async_wait_with_output(self, void* aSemaphoreSignaller, size_t aSemaphoreIndex))
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
GtNativeExternalProcessChild >> primTakeAsynchronousStderrWithSignaller: aSemaphoreSignaller semaphoreIndex: aSemaphoreIndex [
	^ self ffiCall: #(void* process_child_take_asynchronous_stderr_with_semaphore(
		self,
		void* aSemaphoreSignaller,
		size_t aSemaphoreIndex))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessChild >> primTakeAsynchronousStdout [
	^ self ffiCall: #(void* process_child_take_asynchronous_stdout(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessChild >> primTakeAsynchronousStdoutWithSignaller: aSemaphoreSignaller semaphoreIndex: aSemaphoreIndex [
	^ self ffiCall: #(void* process_child_take_asynchronous_stdout_with_semaphore(
		self,
		void* aSemaphoreSignaller,
		size_t aSemaphoreIndex))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessChild >> primTakeStdin [
	^ self ffiCall: #(void* process_child_take_stdin(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessChild >> primTakeStdout [
	^ self ffiCall: #(void* process_child_take_stdout(self))
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

{ #category : #'private - ffi' }
GtNativeExternalProcessChild >> primitiveGetSemaphoreSignaller [
	<primitive: 'primitiveGetSemaphoreSignaller'>

	^ ExternalAddress null
]

{ #category : #private }
GtNativeExternalProcessChild >> quitImage [
	"The image is exiting, kill the process and flag polling to stop"

	^ self primKill
]

{ #category : #'api - process' }
GtNativeExternalProcessChild >> signal: aSignalValue [
	"Send the specified signal to the receiver's OS process.
	Supported on Unix platforms, On Windows, falls back to #kill."
	<return: #Boolean>

	^ self primKillWithSignal: aSignalValue
]

{ #category : #'api - stdio' }
GtNativeExternalProcessChild >> stderrStream [
	"Return an asynchronous stream of stdout characters. The returned stream
	doesn't poll all output into the image, but rather loads it in chunks upon request."
	<return: #TAsyncStream>

	| aSemaphore aSemaphoreIndex anExternalOutput |
	aSemaphore := Semaphore new.
	aSemaphoreIndex := Smalltalk registerExternalObject: aSemaphore.

	anExternalOutput := (GtNativeExternalAsynchronousStdout
			fromNativeHandle: (self
					primTakeAsynchronousStderrWithSignaller: self primitiveGetSemaphoreSignaller
					semaphoreIndex: aSemaphoreIndex)) childProcess: self.

	^ GtExternalProcessStdoutStream
		externalOutput: anExternalOutput
		semaphore: aSemaphore
		semaphoreIndex: aSemaphoreIndex
]

{ #category : #'api - stdio' }
GtNativeExternalProcessChild >> stdin [
	"Try to get child's stdin handle. Please note, that the returned handle may be null if child's stdin is already
	consumed or if child does not have stdin"
	<return: #GtNativeExternalProcessChildStdin>

	^ mutex critical: [ stdin ifNil: [ stdin := GtNativeExternalProcessChildStdin fromNativeHandle: self primTakeStdin ] ]
]

{ #category : #'api - stdio' }
GtNativeExternalProcessChild >> stdoutStream [
	"Return an asynchronous stream of stdout characters. The returned stream
	doesn't poll all output into the image, but rather loads it in chunks upon request."
	<return: #TAsyncStream>

	| aSemaphore aSemaphoreIndex anExternalOutput |
	aSemaphore := Semaphore new.
	aSemaphoreIndex := Smalltalk registerExternalObject: aSemaphore.

	anExternalOutput := (GtNativeExternalAsynchronousStdout
			fromNativeHandle: (self
					primTakeAsynchronousStdoutWithSignaller: self primitiveGetSemaphoreSignaller
					semaphoreIndex: aSemaphoreIndex)) childProcess: self.

	^ GtExternalProcessStdoutStream
		externalOutput: anExternalOutput
		semaphore: aSemaphore
		semaphoreIndex: aSemaphoreIndex
]

{ #category : #ui }
GtNativeExternalProcessChild >> summaryAttributes [
	| attributes exitStatus |

	attributes := OrderedCollection new.
	self isRunning
		ifTrue: [ attributes add: { #Running. true. self. } ]
		ifFalse: 
			[ exitStatus := self wait.
			attributes
				add: { #Successful. exitStatus isSuccess. exitStatus. };
				add: { #Status. exitStatus code ifNil: [ 'terminated by signal without code' ]. exitStatus. } ].
	attributes
		add: { #PID. self id. self. };
		add: { #TerminateOnShutdown. self willTerminateOnShutdown. self. }.
	^ attributes.
]

{ #category : #'api - process' }
GtNativeExternalProcessChild >> terminate [
	"Send the child process SIGTERM and return true if it was succesful. If the child has already exited, false is returned."
	<return: #Boolean>
	| result |

	OSPlatform current isWindows ifTrue: [ ^ self kill ].

	result := self primKillWithSignal: 15.
	"Read the process exit status, otherwise a defunct process will be left behind"
	"The wait is never returning occasionally on linux, to be investigated"
	"self primWait."
	^ result.
]

{ #category : #'api - process' }
GtNativeExternalProcessChild >> terminateAll [
	"Variant of #terminate to also terminate all child processes.
	Return true if it was succesful. 
	If the child has already exited, false is returned."
	<return: #Boolean>
	OSPlatform current isWindows 
		ifTrue: [
			"Use TASKKILL with
				/F [Specifies that processes be forcefully ended]
				/T [Ends the specified process and any child processes started by it]"
			^ (GtExternalProcessBuilder new
				command: 'taskkill';
				arguments: {'/F' . '/T' . '/PID' . self id asString };
				output) status isSuccess ].
	"Assume the normal #terminate already does the right thing"
	"Note however that the regular terminate is not a forced kill"
	^ self terminate
]

{ #category : #'system startup & shutdown' }
GtNativeExternalProcessChild >> terminateOnShutdown [
	"Register the receiver to be killed when Pharo exits"

	self class sessionAnnouncer weak 
		when: GtExternalProcessShutdownAnnouncement
		send: #quitImage
		to: self.
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
GtNativeExternalProcessChild >> waitAsyncWithOutput [
	<return: #GtNativeExternalProcessOutput>
	| aSemaphoreSignaller aSemaphore aSemaphoreIndex |
	
	aSemaphoreSignaller := self primitiveGetSemaphoreSignaller.
	aSemaphoreSignaller isNull
		ifTrue: [ self error: 'Semaphore signaller is not available in the current virtual machine.' ].
	
	aSemaphore := Semaphore new.
	aSemaphoreIndex := Smalltalk registerExternalObject: aSemaphore.
	
	^ GtNativeExternalProcessAsyncOutput
		fromNativeHandle: (self primAsyncWaitWithOutputSignaller: aSemaphoreSignaller semaphoreIndex: aSemaphoreIndex)
		during: [ :anAsyncOutput |
			| anOutput |
			aSemaphore wait.
			Smalltalk unregisterExternalObject: aSemaphore.
			anOutput := anAsyncOutput takeOutput.
			self release.
			anOutput ]
]

{ #category : #'api - process' }
GtNativeExternalProcessChild >> waitForExitDoing: aBlock [
	"Wait for the process to exit, evaluating the block every pollDuration seconds"

	GtNativeExternalProcessPoll 
		child: self
		waitForExitDoing: aBlock
]

{ #category : #'api - process' }
GtNativeExternalProcessChild >> waitWithOutput [
	<return: #GtNativeExternalProcessOutput>
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
