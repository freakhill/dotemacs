Set oShell = CreateObject ("Wscript.Shell")
Dim strArgs
strArgs = "cmd /c d:/emacsclient.bat"
oShell.Run strArgs, 0, false
