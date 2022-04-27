Class {
	#name : #GtExternalProcessNullStdio,
	#superclass : #GtExternalProcessStdio,
	#category : #'GToolkit-ExternalProcess-Core'
}

{ #category : #converting }
GtExternalProcessNullStdio >> asNativeStdioIn: aWorkingDirectory during: aBlock [
	^ GtNativeExternalProcessStdioNull newDuring: aBlock
]
