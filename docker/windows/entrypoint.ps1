dir env:

Exec-NativeProgram { qmake "PLUGIN_VERSION = $1" }
Exec-NativeProgram { nmake package }
