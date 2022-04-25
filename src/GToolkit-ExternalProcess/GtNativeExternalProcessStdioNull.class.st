Class {
	#name : #GtNativeExternalProcessStdioNull,
	#superclass : #GtNativeExternalProcessStdio,
	#category : #'GToolkit-ExternalProcess-External'
}

{ #category : #'private - ffi' }
GtNativeExternalProcessStdioNull class >> primCreate [
	^ self ffiCall: #(void* process_stdio_null())
]
