Class {
	#name : #GtExternalProcessOutputFuture,
	#superclass : #Object,
	#traits : 'TAsyncFuture',
	#classTraits : 'TAsyncFuture classTrait',
	#instVars : [
		'asyncOutput',
		'output',
		'waker',
		'externalProcessChild',
		'processBuilder'
	],
	#classVars : [
		'WaitFutures',
		'WaitMutex',
		'WaitProcess',
		'WaitSemaphore',
		'WaitSemaphoreIndex'
	],
	#category : #'GToolkit-ExternalProcess-Core'
}

{ #category : #'class initialization' }
GtExternalProcessOutputFuture class >> forProcessBuilder: aGtExternalProcessBuilder [
	^ self new
		processBuilder: aGtExternalProcessBuilder copy
]

{ #category : #'class initialization' }
GtExternalProcessOutputFuture class >> initialize [
	WaitMutex := Monitor new.
	WaitSemaphore := Semaphore new.
	WaitSemaphoreIndex := Smalltalk registerExternalObject: WaitSemaphore.
	WaitFutures := OrderedCollection new.
	WaitProcess := nil.
]

{ #category : #'class initialization' }
GtExternalProcessOutputFuture class >> newWaitProcess [
	[
		WaitSemaphore waitTimeoutSeconds: 5.
		WaitMutex critical: [
			WaitFutures := WaitFutures
				reject: [ :eachFuture | eachFuture attemptToTakeOutput ].
			WaitFutures ifEmpty: [
				WaitProcess := nil.
				^ self ] ]
	] repeat
]

{ #category : #private }
GtExternalProcessOutputFuture >> attemptToTakeOutput [
	output ifNotNil: [ ^ true ].
	
	output := asyncOutput tryTakeOutput.
	^ output
		ifNotNil: [
			waker wakeUp.
			true ]
		ifNil: [ false ]
]

{ #category : #initialization }
GtExternalProcessOutputFuture >> initialize [
	super initialize.
	
	waker := AsyncFutureExecutionAtomicWaker new.
	asyncOutput := nil.
	output := nil.
]

{ #category : #'api - future' }
GtExternalProcessOutputFuture >> poll: anAsynchronousContext [
	<return: #AsyncPoll>
	
	externalProcessChild ifNil: [
		externalProcessChild := processBuilder copy
			pipeStdout;
			pipeStderr;
			spawn ].

	asyncOutput ifNil: [
		| aSemaphoreSignaller anAsyncOutput |
	
		aSemaphoreSignaller := externalProcessChild primitiveGetSemaphoreSignaller.
		aSemaphoreSignaller isNull
			ifTrue: [ self error: 'Semaphore signaller is not available in the current virtual machine.' ].
		
		anAsyncOutput := GtNativeExternalProcessAsyncOutput
			fromNativeHandle: (externalProcessChild
				primAsyncWaitWithOutputSignaller: aSemaphoreSignaller
				semaphoreIndex: WaitSemaphoreIndex).

		asyncOutput := anAsyncOutput.
		
		WaitMutex critical: [
			WaitFutures add: self.
			WaitProcess ifNil: [
				WaitProcess := [
						self class newWaitProcess
					] newProcess
					name: 'External process output futures';
					priority: Processor userInterruptPriority;
					resume.
			
			].
		]
	].
	
	^ output
		ifNil: [
			waker register: anAsynchronousContext waker.
			AsyncPoll pending ]
		ifNotNil: [ :anOutput | AsyncPoll ready: anOutput ]	
]

{ #category : #'api - future copy' }
GtExternalProcessOutputFuture >> postSimilarCopy [
	"Is called by similarCopy. self is a shallow copy, implementors should set the fields as necessary to complete the similar copy"
	
	asyncOutput := nil.
	output := nil.
	waker := AsyncFutureExecutionAtomicWaker new.
	externalProcessChild := nil
]

{ #category : #accessing }
GtExternalProcessOutputFuture >> processBuilder [
	^ processBuilder
]

{ #category : #accessing }
GtExternalProcessOutputFuture >> processBuilder: anObject [
	processBuilder := anObject
]
