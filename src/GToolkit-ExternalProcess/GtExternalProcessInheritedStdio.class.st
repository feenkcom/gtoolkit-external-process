"
#Inherited stdio
The child inherits from the corresponding parent descriptor.

`""hello world""` echoed to console:
{{gtExample:GtExternalProcessExamples>>inheritedHelloWorld}}
"
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
GtExternalProcessInheritedStdio >> applyOnStdinOf: aGtNativeExternalCommand [
	aGtNativeExternalCommand inheritStdin
]

{ #category : #dispatch }
GtExternalProcessInheritedStdio >> applyOnStdoutOf: aGtNativeExternalCommand [
	aGtNativeExternalCommand inheritStdout
]
