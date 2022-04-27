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

{ #category : #converting }
GtExternalProcessInheritedStdio >> asNativeStdioIn: aWorkingDirectory during: aBlock [
	^ GtNativeExternalProcessStdioInherited newDuring: aBlock
]
