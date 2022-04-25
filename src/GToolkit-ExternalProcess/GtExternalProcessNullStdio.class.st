Class {
	#name : #GtExternalProcessNullStdio,
	#superclass : #GtExternalProcessStdio,
	#category : #'GToolkit-ExternalProcess-Core'
}

{ #category : #converting }
GtExternalProcessNullStdio >> asNativeStdioDuring: aBlock [
	^ GtNativeExternalProcessStdioNull newDuring: aBlock
]
