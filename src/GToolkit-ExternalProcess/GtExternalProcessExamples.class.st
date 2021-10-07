Class {
	#name : #GtExternalProcessExamples,
	#superclass : #Object,
	#category : #'GToolkit-ExternalProcess-Examples'
}

{ #category : #examples }
GtExternalProcessExamples >> processBuilder [
	<gtExample>
	| aProcessBuilder |
	
	aProcessBuilder := GtExternalProcessBuilder new
		command: 'ls';
		arg: '-la'
]
