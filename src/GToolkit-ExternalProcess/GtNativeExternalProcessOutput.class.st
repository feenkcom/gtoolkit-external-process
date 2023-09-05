Class {
	#name : #GtNativeExternalProcessOutput,
	#superclass : #GtBoxerValueBox,
	#traits : 'TGtExternalProcessLibrary',
	#classTraits : 'TGtExternalProcessLibrary classTrait',
	#category : #'GToolkit-ExternalProcess-External'
}

{ #category : #'private - ffi' }
GtNativeExternalProcessOutput class >> primRelease: aHandle [
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	^ self ffiCall: #(void process_output_drop(void* aHandle))
]

{ #category : #accessing }
GtNativeExternalProcessOutput >> gtStatusFor: aView [
	<gtView>
	
	^ aView forward
		title: 'Status';
		priority: 4;
		object: [ self status ];
		view: #gtInfoFor:
]

{ #category : #accessing }
GtNativeExternalProcessOutput >> gtStderrFor: aView [
	<gtView>
	
	self stderrString
		ifEmpty: [ ^ aView empty ].
	
	^ aView text
		title: 'Stderr';
		priority: 2;
		text: [ self stderrString asRopedText glamorousCodeFont ]
]

{ #category : #accessing }
GtNativeExternalProcessOutput >> gtStdoutFor: aView [
	<gtView>
	
	^ aView text
		title: 'Stdout';
		priority: 3;
		text: [ self stdoutString asRopedText glamorousCodeFontAndSmallSize ]
]

{ #category : #'private - ffi' }
GtNativeExternalProcessOutput >> primtGetStatus [
	^ self ffiCall: #(void* process_output_status(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessOutput >> primtGetStderr [
	^ self ffiCall: #(void* process_output_stderr(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessOutput >> primtGetStderrString [
	^ self ffiCall: #(void* process_output_stderr_string(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessOutput >> primtGetStdout [
	^ self ffiCall: #(void* process_output_stdout(self))
]

{ #category : #'private - ffi' }
GtNativeExternalProcessOutput >> primtGetStdoutString [
	^ self ffiCall: #(void* process_output_stdout_string(self))
]

{ #category : #accessing }
GtNativeExternalProcessOutput >> status [
	<return: #String>

	^ GtNativeExternalProcessExitStatus fromNativeHandle: self primtGetStatus
]

{ #category : #accessing }
GtNativeExternalProcessOutput >> stderr [
	<return: #String>

	^ self stderrString
]

{ #category : #accessing }
GtNativeExternalProcessOutput >> stderrBytes [
	<return: #ByteArray>
	
	^ self ffiLibrary
		newArrayU8FromHandle: self primtGetStderr
		during: [ :anArrayU8 | anArrayU8 asByteArray ]
]

{ #category : #accessing }
GtNativeExternalProcessOutput >> stderrString [
	<return: #String>
	
	^ self ffiLibrary
		newStringFromHandle: self primtGetStderrString
		during: [ :aStringBox | aStringBox string ]
]

{ #category : #accessing }
GtNativeExternalProcessOutput >> stdout [
	<return: #String>

	^ self stdoutString
]

{ #category : #accessing }
GtNativeExternalProcessOutput >> stdoutBytes [
	<return: #ByteArray>

	^ self ffiLibrary
		newArrayU8FromHandle: self primtGetStdout
		during: [ :anArrayU8 | anArrayU8 asByteArray ]
]

{ #category : #accessing }
GtNativeExternalProcessOutput >> stdoutString [
	<return: #String>

	^ self ffiLibrary
		newStringFromHandle: self primtGetStdoutString
		during: [ :aStringBox | aStringBox string ]
]
