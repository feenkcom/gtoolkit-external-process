"
GtNativeExternalProcessPoll provides a convenient, efficient method of polling the external process on a fixed time basis while it is running.  This is typically used to retrieve output from the process to prevent block on writing to a pipe.

GtNativeExternalProcessPoll is not normally used directly, but through {{gtMethod:GtNativeExternalProcessChild>>#waitForExitDoing:}}.

Ideally GtNativeExternalProcessPoll just waits for the child process to exit, and then stops evaluting the supplied BlockClosure.  While waiting for #wait to be implemented, we poll for process exit.  The wait code is left here in anticipation.
"
Class {
	#name : #GtNativeExternalProcessPoll,
	#superclass : #Object,
	#instVars : [
		'child',
		'exitProcess',
		'semaphore',
		'pollDuration'
	],
	#category : #'GToolkit-ExternalProcess-External'
}

{ #category : #accessing }
GtNativeExternalProcessPoll class >> child: aGtNativeExternalProcessChild [

	^ self new child: aGtNativeExternalProcessChild 
]

{ #category : #accessing }
GtNativeExternalProcessPoll class >> child: aGtNativeExternalProcessChild waitForExitDoing: aBlock [

	^ self new 
		child: aGtNativeExternalProcessChild;
		waitForExitDoing: aBlock
]

{ #category : #accessing }
GtNativeExternalProcessPoll >> child [

	^ child
]

{ #category : #accessing }
GtNativeExternalProcessPoll >> child: aGtNativeExternalProcessChild [
	"Set the receiver's child process, which is assumed to be already running"

	child := aGtNativeExternalProcessChild.
	"self initializeExitProcess."
]

{ #category : #initialization }
GtNativeExternalProcessPoll >> initialize [

	super initialize.
	semaphore := Semaphore new.
	"pollDuration := 500." "milliSeconds"
	pollDuration := 50 milliSeconds.

]

{ #category : #initialization }
GtNativeExternalProcessPoll >> initializeExitProcess [
	"Start the process waiting for the child process to exit"

	exitProcess := 
		[ child wait.
		semaphore signal ] forkNamed: 'GtNativeExternalProcessPoll exitProcess'.
]

{ #category : #accessing }
GtNativeExternalProcessPoll >> pollDuration [

	^ pollDuration
]

{ #category : #accessing }
GtNativeExternalProcessPoll >> pollDuration: anObject [

	pollDuration := anObject
]

{ #category : #private }
GtNativeExternalProcessPoll >> throttlePollDuration [
	"Progressively slow the poll duration to something over 500mS.
	This balances the desire to poll of short lived processes frequently and long lived processes rarely."

	pollDuration asNanoSeconds < 500000000 ifTrue:
		[ pollDuration := Duration nanoSeconds: 
			(pollDuration asNanoSeconds * 2 min: 500000000) ].
]

{ #category : #waiting }
GtNativeExternalProcessPoll >> waitForExitDoing: aBlock [
	"Wait for the process to exit, evaluating the block every pollDuration seconds.
	The semaphore exits every pollDuration milliseconds, allowing the supplied block to be evaluated.
	When the child process exits, the exitProcess will signal the semaphore, cause the loop to finish (the child isTerminated)."

	"[ semaphore waitTimeoutMSecs: pollDuration.
	child isTerminated ] whileFalse:
		[ aBlock cull: child ]."
	[ pollDuration wait.
	child isTerminated ] whileFalse:
		[ aBlock cull: child.
		self throttlePollDuration ].

	"Catch anything that may have be written during the last wait"
	aBlock cull: child.
]
