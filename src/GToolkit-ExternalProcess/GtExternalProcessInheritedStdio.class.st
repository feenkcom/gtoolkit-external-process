Class {
	#name : #GtExternalProcessInheritedStdio,
	#superclass : #GtExternalProcessStdio,
	#category : #'GToolkit-ExternalProcess-Core'
}

{ #category : #dispatch }
GtExternalProcessInheritedStdio >> applyOnStderrOf: aGtNativeExternalCommand [
	aGtNativeExternalCommand inheritStderr
]

{ #category : #dispatch }
GtExternalProcessInheritedStdio >> applyOnStdoutOf: aGtNativeExternalCommand [
	aGtNativeExternalCommand inheritStdout
]
