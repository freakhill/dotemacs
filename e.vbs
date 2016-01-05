Set oShell = CreateObject ("Wscript.Shell")
Dim strArgs
strArgs = "cmd /c" & chr(34) & "C:/ProgramData/chocolatey/bin/emacsclientw.exe -c -f C:/Users/jp11629.LINECORP/.emacs.d/server/server -na C:/Users/jp11629.LINECORP/.emacs.d/emacsserver.bat"
oShell.Run strArgs, 0, false
