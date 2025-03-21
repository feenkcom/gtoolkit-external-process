Class {
	#name : #GtExternalProcessExamples,
	#superclass : #Object,
	#instVars : [
		'file'
	],
	#category : #'GToolkit-ExternalProcess-Examples'
}

{ #category : #private }
GtExternalProcessExamples >> cleanUp [

	file ifNotNil: [ file ensureDelete ]
]

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

{ #category : #examples }
GtExternalProcessExamples >> pipeLargeFile [
	"Demonstrate piping the output of a process with large output"

	<gtExample>
	<after: #cleanUp>
	| anOutput stdout fileContents isWindows |
	file := FileReference newTempFilePrefix: 'pipeLargeFile-' suffix: '.txt'.
	file ensureDelete.
	file
		writeStreamDo: [ :stream | stream nextPutAll: (String loremIpsum: 15 * (1024 ** 2)) ].
	isWindows := OSPlatform current isWindows.
	anOutput := isWindows
			ifTrue: [ GtExternalProcessBuilder new
					command: 'cmd';
					args: {'/C'.
							'type ' , file fullName};
					output ]
			ifFalse: [ | script |
				script := String
						streamContents: [ :stream | 
							stream
								<< 'cat ';
								<< file fullName;
								<< ';';
								lf;
								<< 'cat ';
								<< file fullName;
								<< ' >&2';
								lf ].
				GtExternalProcessBuilder new
					command: 'sh';
					args: {'-c'.
							script};
					output ].
	fileContents := file contents trimBoth.
	stdout := anOutput stdout trimBoth.
	self assert: stdout equals: fileContents.
	isWindows
		ifFalse: [ | stderr |
			stderr := anOutput stderr trimBoth.
			self assert: stderr equals: fileContents ].
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
	
	OSPlatform current isWindows
		ifTrue: [ ^ #() ].
	
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
