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

{ #category : #'examples - stdio' }
GtExternalProcessExamples >> inheritedHelloWorld [
	<gtExample>
	| output stdout |

	output := GtExternalProcessBuilder new
		command: 'echo';
		arg: 'hello world';
		inheritStdout;
		output.

	stdout := output stdout trimBoth.
		
	self assert: stdout equals: ''.
	
	^ stdout
]

{ #category : #'examples - stdio' }
GtExternalProcessExamples >> pipedHelloWorld [
	<gtExample>
	| output stdout |

	output := GtExternalProcessBuilder new
		command: 'echo';
		arg: 'hello world';
		pipeStdout;
		output.

	stdout := output stdout trimBoth.
		
	self assert: stdout equals: 'hello world'.
	
	^ stdout
]

{ #category : #examples }
GtExternalProcessExamples >> setAndEchoEnvVar [
	<gtExample>
	<noTest>
	| anOutput anStdout |

	anOutput := OSPlatform current isWindows
		ifTrue: [
			GtExternalProcessBuilder new
				command: 'cmd';
				env: #MY_VAR value: 'hello';
				args: #('/C' 'echo $MY_VAR');
				output ]
		ifFalse: [
			GtExternalProcessBuilder new
				command: 'sh';
				env: #MY_VAR value: 'hello';
				args: #('-c' 'echo $MY_VAR');
				output ].

	anStdout := anOutput stdout trimBoth.
	self assert: anStdout equals: 'hello'.
	
	^ anStdout
]
