Class {
	#name : #GtExternalProcessBuilder,
	#superclass : #Object,
	#instVars : [
		'command',
		'arguments'
	],
	#category : #'GToolkit-ExternalProcess-Process'
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

	^ anExternalCommand
]

{ #category : #initialization }
GtExternalProcessBuilder >> initialize [
	super initialize.
	
	arguments := OrderedCollection new
]

{ #category : #'api - spawning' }
GtExternalProcessBuilder >> output [
	^ self createNativeCommand output
]

{ #category : #'api - spawning' }
GtExternalProcessBuilder >> spawn [
	^ self createNativeCommand spawn
]
