"
#Default stdio

Defaults to `inherit` when used with `#spawn` or `#status`, and defaults to `piped` when used with `#output`
"
Class {
	#name : #GtExternalProcessDefaultStdio,
	#superclass : #GtExternalProcessStdio,
	#category : #'GToolkit-ExternalProcess-Core'
}
