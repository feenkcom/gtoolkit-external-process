Class {
	#name : #GtExternalProcessExamples,
	#superclass : #Object,
	#category : #'GToolkit-ExternalProcess-Examples'
}

{ #category : #examples }
GtExternalProcessExamples >> defaultProcessBuilder [
	<gtExample>
	| aProcessBuilder |
	
	aProcessBuilder := GtExternalProcessBuilder new
		command: 'date'.
		
	^ aProcessBuilder
]

{ #category : #examples }
GtExternalProcessExamples >> echoHello [
	<gtExample>
	| anOutput anStdout |
	
	anOutput := OSPlatform current isWindows
		ifTrue: [
			GtExternalProcessBuilder new
				command: 'cmd';
				args: #('/C' 'echo hello');
				output ]
		ifFalse: [ 
			GtExternalProcessBuilder new
				command: 'sh';
				args: #('-c' 'echo hello');
				output ].

	anStdout := anOutput stdout trimBoth.
	self assert: anStdout equals: 'hello'.
	
	^ anStdout
]
