Class {
	#name : #GtExternalProcessStdoutToStdio,
	#superclass : #GtExternalProcessStdio,
	#instVars : [
		'externalProcessChild'
	],
	#category : #'GToolkit-ExternalProcess-Core'
}

{ #category : #converting }
GtExternalProcessStdoutToStdio >> asNativeStdioIn: aWorkingDirectory during: aBlock [
	^ GtNativeExternalProcessChildStdoutStdio
		fromChildStdout: externalProcessChild primTakeStdout
		during: aBlock
]

{ #category : #accessing }
GtExternalProcessStdoutToStdio >> externalProcessChild [
	^ externalProcessChild
]

{ #category : #accessing }
GtExternalProcessStdoutToStdio >> externalProcessChild: anObject [
	externalProcessChild := anObject
]
