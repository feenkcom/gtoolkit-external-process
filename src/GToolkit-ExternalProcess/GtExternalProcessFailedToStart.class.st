Class {
	#name : #GtExternalProcessFailedToStart,
	#superclass : #Error,
	#instVars : [
		'child'
	],
	#category : #'GToolkit-ExternalProcess'
}

{ #category : #accessing }
GtExternalProcessFailedToStart >> child [
	^ child
]

{ #category : #accessing }
GtExternalProcessFailedToStart >> child: anObject [
	child := anObject
]
