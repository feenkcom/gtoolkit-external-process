Class {
	#name : #GtExternalProcessStdio,
	#superclass : #Object,
	#category : #'GToolkit-ExternalProcess-Core'
}

{ #category : #converting }
GtExternalProcessStdio >> asNativeStdioIn: aWorkingDirectory during: aBlock [
	self subclassResponsibility
]
