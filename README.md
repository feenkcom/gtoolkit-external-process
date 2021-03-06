# gtoolkit-external-process
A Pharo library for cross-platform running of external commands and getting their output.

## Supported platforms:
Linux, Windows, MacOS

## How to load

Compile or download a released shared library for your platform from https://github.com/feenkcom/libprocess/releases and place it in the same folder as `GlamorousToolkit.image` or in the corresponding libraries folder inside of the `GlamorousToolkit` app.

```smalltalk
Metacello new
   baseline: 'GToolkitExternalProcess';
   repository: 'github://feenkcom/gtoolkit-external-process:main/src';
   load.
```

## Usage

### Synchronous output
Create an external command with a builder and spawn a child process or wait for the output. Then get the output status, stdout or stderr:

```smalltalk
output := GtExternalProcessBuilder new
   command: 'ls';
   arg: '-la';
   output.
	
output stdoutString
```

### Buffered non-blocking IO

Pipe the stdout or stderr and poll regularly from an asynchronousStdout:

```smalltalk
child := GtExternalProcessBuilder new
   command: 'ping';
   arg: 'google.com';
   pipeStdout;
   spawn.

child asynchronousStdout
   pollStringEvery: 1 second
   do: [ :aString | aString trace ].

"kill when done"
child kill.
```
