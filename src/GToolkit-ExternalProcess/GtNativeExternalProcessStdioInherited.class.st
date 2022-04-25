Class {
	#name : #GtNativeExternalProcessStdioInherited,
	#superclass : #GtNativeExternalProcessStdio,
	#category : #'GToolkit-ExternalProcess-External'
}

{ #category : #'private - ffi' }
GtNativeExternalProcessStdioInherited class >> primCreate [
	^ self ffiCall: #(void* process_stdio_inherit())
]
