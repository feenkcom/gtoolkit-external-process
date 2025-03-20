"
GtExternalProcessOutputHolder provides a (partially) compatible API to {{gtClass:GtNativeExternalProcessOutput}} when output is retrieved progressively while a process is being run.
"
Class {
	#name : #GtExternalProcessOutputHolder,
	#superclass : #Object,
	#instVars : [
		'status',
		'stdout',
		'stderr'
	],
	#category : #'GToolkit-ExternalProcess-Compatibility'
}

{ #category : #'instance creation' }
GtExternalProcessOutputHolder class >> status: aStatus stdout: aStdoutString stderr: aStderrString [

	^ self new initializeStatus: aStatus stdout: aStdoutString stderr: aStderrString
]

{ #category : #initialization }
GtExternalProcessOutputHolder >> initializeStatus: aStatus stdout: aStdoutString stderr: aStderrString [

	status := aStatus.
	stdout := aStdoutString.
	stderr := aStderrString.
]

{ #category : #accessing }
GtExternalProcessOutputHolder >> status [
	^status
]

{ #category : #accessing }
GtExternalProcessOutputHolder >> stderr [
	^stderr
]

{ #category : #accessing }
GtExternalProcessOutputHolder >> stdout [
	^stdout
]
