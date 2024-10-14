Class {
	#name : #GtExternalProcessOutputStream,
	#superclass : #Object,
	#traits : 'TAsyncStream',
	#classTraits : 'TAsyncStream classTrait',
	#instVars : [
		'semaphore',
		'semaphoreIndex',
		'waker',
		'outputBuffer',
		'externalOutput',
		'bufferProcess'
	],
	#category : #'GToolkit-ExternalProcess-Core'
}

{ #category : #'instance creation ' }
GtExternalProcessOutputStream class >> externalOutput: aNativeExternalOutput semaphore: aSemaphore semaphoreIndex: aSemaphoreIndex [
	^ self new
		setExternalOutput: aNativeExternalOutput
		semaphore: aSemaphore
		semaphoreIndex: aSemaphoreIndex
]

{ #category : #'api - stream' }
GtExternalProcessOutputStream >> bufferProcess [
	[
		((semaphore waitTimeoutSeconds: 1) not
			or: [ externalOutput isEndOfStreamReached ])
				ifTrue: [ waker wakeUp ].
		externalOutput isEndOfStreamReached
	
	] whileFalse.

	self cleanUpBufferProcess
]

{ #category : #'api - stream' }
GtExternalProcessOutputStream >> cleanUpBufferProcess [
	"At this point we know that the external output has nothing else to offer and it will
	not signall the semaphore anymore. We are free to eagerly unregister an external semaphore
	to not occupy a slot in an external objects set whose size it limited."

	externalOutput releaseSemaphoreSignaller.
	Smalltalk unregisterExternalObject: semaphore
]

{ #category : #'api - stream' }
GtExternalProcessOutputStream >> ensureBufferProcess [
	bufferProcess
		lock: [ :aBufferProcess |  ]
		ifNilPut: [ [ self bufferProcess ] newProcess
				name: 'External Output Stream';
				priority: Processor lowestPriority + 1;
				resume ]
]

{ #category : #initialization }
GtExternalProcessOutputStream >> initialize [
	super initialize.
	
	waker := AsyncFutureExecutionAtomicWaker new.
	outputBuffer := AsyncMutex for: nil.
	bufferProcess := AsyncMutex for: nil.
]

{ #category : #'api - stream' }
GtExternalProcessOutputStream >> pollNext: anAsynchronousContext [
	"Attempt to pull out the next value of this stream, registering the current task for wakeup if the value is not yet available, and returning None if the stream is exhausted.
	There are several possible return values, each indicating a distinct stream state:
	 - Poll::Pending means that this stream's next value is not ready yet. Implementations will ensure that the current task will be notified when the next value may be ready.
	 - Poll::Ready(Some(val)) means that the stream has successfully produced a value, val, and may produce further values on subsequent poll_next calls.
	 - Poll::Ready(None) means that the stream has terminated, and poll_next should not be invoked again."
	<return: #AsyncPoll>

	[ outputBuffer
		lock: [ :aStringReadStreamOrNil | 
			aStringReadStreamOrNil
				ifNil: [ | aPolledString |
					self ensureBufferProcess.
					aPolledString := self pollOutputString.
					aPolledString
						ifEmpty: [ waker register: anAsynchronousContext waker.
							^ AsyncPoll pending ] ]
				ifNotNil: [ :aStringReadStream | 
					aStringReadStream atEnd
						ifTrue: [ externalOutput isEndOfStreamReached
								ifTrue: [ | aPolledString |
									aPolledString := self pollOutputString.
									aPolledString ifEmpty: [ ^ AsyncPoll ready: AsyncOptionalValue none ] ]
								ifFalse: [ | aPolledString |
									aPolledString := self pollOutputString.
									aPolledString
										ifEmpty: [ waker register: anAsynchronousContext waker.
											^ AsyncPoll pending ] ] ]
						ifFalse: [ ^ AsyncPoll
								ready: (AsyncOptionalValue some: aStringReadStream next) ] ] ] ] repeat
]

{ #category : #'api - stream' }
GtExternalProcessOutputStream >> pollOutputString [
	| aPolledString |
	aPolledString := externalOutput pollStringUpTo: 1024.
	outputBuffer value: aPolledString readStream.
	^ aPolledString
]

{ #category : #'api - stream copy' }
GtExternalProcessOutputStream >> postSimilarCopy [
	"Is called by similarCopy. self is a shallow copy, implementors should set the fields as necessary to complete the similar copy"

	waker := AsyncFutureExecutionAtomicWaker new.
	outputBuffer := AsyncMutex for: nil.
	bufferProcess := AsyncMutex for: nil
]

{ #category : #initialization }
GtExternalProcessOutputStream >> setExternalOutput: aNativeExternalOutput semaphore: aSemaphore semaphoreIndex: aSemaphoreIndex [
	externalOutput := aNativeExternalOutput.
	semaphore := aSemaphore.
	semaphoreIndex := aSemaphoreIndex
]
