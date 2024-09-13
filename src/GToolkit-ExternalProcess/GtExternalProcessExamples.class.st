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
GtExternalProcessExamples >> pipeStdoutToStdin [
	<gtExample>
	| parent output stdout |
	
	OSPlatform current isWindows
		ifTrue: [ ^ '' ].

	parent := (GtExternalProcessBuilder new: 'echo')
		arg: 'hello';
		pipeStdout;
		spawn.

	output := (GtExternalProcessBuilder new: 'wc')
		arg: '-m';
		stdoutToStdin: parent;
		output.

	stdout := output stdoutString trimBoth.
	self assert: stdout equals: '6'.
	
	^ stdout
]

{ #category : #'examples - stdio' }
GtExternalProcessExamples >> pipedHelloWorld [
	<gtExample>
	<noTest>
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

{ #category : #'examples - stdio' }
GtExternalProcessExamples >> stdoutStream [
	<gtExample>
	| process lines |
	
	process := GtExternalProcessBuilder new
		command: 'echo';
		arg: 'hello world';
		pipeStdout;
		spawn.

	lines := process stdoutStream lines toArray wait.
	self assert: lines size equals: 1.
	self assert: lines first equals: 'hello world'.

	^ lines
]

{ #category : #'examples - stdio' }
GtExternalProcessExamples >> writeToStdin [
	<gtExample>
	| process stdout |
	
	OSPlatform current isWindows
		ifTrue: [ ^ '' ].

	process := (GtExternalProcessBuilder new: 'wc')
		arg: '-c';
		pipeStdin;
		pipeStdout;
		spawn.

	process stdin
		nextPutAll: 'hello';
		close.

	stdout := process waitWithOutput stdout trimBoth.
		
	self assert: stdout equals: '5'.
	
	^ stdout
]
