Class {
	#name : #GtExternalProcessBuilder,
	#superclass : #Object,
	#instVars : [
		'command',
		'arguments',
		'stdout',
		'stderr'
	],
	#category : #'GToolkit-ExternalProcess-Core'
}

{ #category : #accessing }
GtExternalProcessBuilder >> arg: anArgumentString [
	arguments add: anArgumentString
]

{ #category : #accessing }
GtExternalProcessBuilder >> args: anObject [

	arguments := anObject asOrderedCollection
]

{ #category : #accessing }
GtExternalProcessBuilder >> arguments [

	^ arguments
]

{ #category : #accessing }
GtExternalProcessBuilder >> command [
	^ command
]

{ #category : #accessing }
GtExternalProcessBuilder >> command: aString [
	command := aString
]

{ #category : #private }
GtExternalProcessBuilder >> createNativeCommand [
	| anExternalCommand |
	
	anExternalCommand := GtNativeExternalProcessCommand new: self command.
	arguments do: [ :eachArgument | anExternalCommand arg: eachArgument ].
	stdout applyOnStdoutOf: anExternalCommand.
	stderr applyOnStderrOf: anExternalCommand.

	^ anExternalCommand
]

{ #category : #accessing }
GtExternalProcessBuilder >> inheritStderr [
	stderr := GtExternalProcessInheritedStdio new
]

{ #category : #accessing }
GtExternalProcessBuilder >> inheritStdout [
	stdout := GtExternalProcessInheritedStdio new
]

{ #category : #initialization }
GtExternalProcessBuilder >> initialize [
	super initialize.
	
	arguments := OrderedCollection new.
	stdout := GtExternalProcessInheritedStdio new.
	stderr := GtExternalProcessInheritedStdio new
]

{ #category : #'api - spawning' }
GtExternalProcessBuilder >> output [
	^ self createNativeCommand output
]

{ #category : #accessing }
GtExternalProcessBuilder >> pipeStderr [
	stderr := GtExternalProcessPipedStdio new
]

{ #category : #accessing }
GtExternalProcessBuilder >> pipeStdout [
	stdout := GtExternalProcessPipedStdio new
]

{ #category : #'api - spawning' }
GtExternalProcessBuilder >> spawn [
	^ self createNativeCommand spawn
]
