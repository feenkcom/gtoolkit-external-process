Class {
	#name : #GtExternalProcessBuilder,
	#superclass : #Object,
	#instVars : [
		'command',
		'arguments',
		'stdout',
		'stderr',
		'workingDirectory',
		'windowsProcessCreationFlags'
	],
	#classVars : [
		'WINDOWS_CREATE_NO_WINDOW',
		'WINDOWS_DETACHED_PROCESS'
	],
	#category : #'GToolkit-ExternalProcess-Core'
}

{ #category : #initialization }
GtExternalProcessBuilder class >> initialize [
	"See https://docs.microsoft.com/en-us/windows/win32/procthread/process-creation-flags"
	
	WINDOWS_DETACHED_PROCESS := 16r00000008.
	WINDOWS_CREATE_NO_WINDOW := 16r08000000
]

{ #category : #accessing }
GtExternalProcessBuilder >> arg: anArgumentString [
	arguments add: anArgumentString
]

{ #category : #accessing }
GtExternalProcessBuilder >> args: aCollection [
	arguments addAll: aCollection
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
	workingDirectory ifNotNil: [ anExternalCommand workingDirectory: workingDirectory ].

	stdout applyOnStdoutOf: anExternalCommand.
	stderr applyOnStderrOf: anExternalCommand.
	
	OSPlatform current isWindows
		ifTrue: [ anExternalCommand windowsProcessCreationFlags: windowsProcessCreationFlags ].
	
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
	stdout := GtExternalProcessDefaultStdio new.
	stderr := GtExternalProcessDefaultStdio new.
	
	"windows specific"
	windowsProcessCreationFlags := WINDOWS_CREATE_NO_WINDOW
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

{ #category : #accessing }
GtExternalProcessBuilder >> workingDirectory: aFileReference [
	workingDirectory := aFileReference asFileReference
]
