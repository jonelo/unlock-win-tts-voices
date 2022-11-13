# unlock-win-tts-voices.bat
This batch script is for end users and unlocks the Microsoft Windows TTS voices for use with other x64 applications such as PowerShell. You can call the batch as often as needed.

## What does it?
The batch prints a list of TTS voices that powershell can see. Then the batch asks the user whether the TTS voices should be unlocked. After the acutal action, the batch prints again a list of TTS voices powershell can see.

### Running the script
Open a PowerShell (using normal permissions), and change to the directory where you have stored the batch file. On my computer I have stored it to Applications\bin. Launch it simply by typing `.\unlock-win-tts-voices.bat`:

<img width="80%" src="https://raw.githubusercontent.com/jonelo/unlock-win-tts-voices/main/docs/images/powershell_unlock-win-tts-voices.png" alt="unlock_win_tts-voices in action" style="vertical-align:top;margin:10px 10px" />

## Development details
### How the unlock works
There is a small PowerShell script on the web (see credits) that simple copies a particular registry tree to another. Actally that action enables other applications to use the OS TTS voices.

### Circumvent the powershell hurdles 
The problem with powershell scripts is that they have an ExecutionPolicy applied which makes it difficult to run for end users. Also the powershell script requires admin priviledges because the script wants to modify the registry. 

I have solved those problems by cascading two powershell commands. The first powershell is being called with the verb RunAs which enables the user to allow Admin priviledges and the second powershell is being called by the first one using Start-Process which executes the actual powershell script with a hidden Windows style and Unrestricted ExecutionPolicy. Also, in order to avoid trouble with escaping the script calls the powershell script as a UTF16le/base64 encoded command.

Here ist the final code line in batch syntax:
```
powershell.exe -Command "Start-Process -WindowStyle Hidden -FilePath powershell.exe -ArgumentList \"-ExecutionPolicy Unrestricted -EncodedCommand JABzAG8AdQByAGMAZQBQAGEAdABoACAAPQAgACcASABLAEwATQA6AFwAcwBvAGYAdAB3AGEAcgBlAFwATQBpAGMAcgBvAHMAbwBmAHQAXABTAHAAZQBlAGMAaABfAE8AbgBlAEMAbwByAGUAXABWAG8AaQBjAGUAcwBcAFQAbwBrAGUAbgBzACcAOwAgACQAZABlAHMAdABpAG4AYQB0AGkAbwBuAFAAYQB0AGgAIAA9ACAAJwBIAEsATABNADoAXABTAE8ARgBUAFcAQQBSAEUAXABNAGkAYwByAG8AcwBvAGYAdABcAFMAcABlAGUAYwBoAFwAVgBvAGkAYwBlAHMAXABUAG8AawBlAG4AcwAnADsAIABjAGQAIAAkAGQAZQBzAHQAaQBuAGEAdABpAG8AbgBQAGEAdABoADsAIAAkAGwAaQBzAHQAVgBvAGkAYwBlAHMAIAA9ACAARwBlAHQALQBDAGgAaQBsAGQASQB0AGUAbQAgACQAcwBvAHUAcgBjAGUAUABhAHQAaAA7ACAAZgBvAHIAZQBhAGMAaAAoACQAdgBvAGkAYwBlACAAaQBuACAAJABsAGkAcwB0AFYAbwBpAGMAZQBzACkAIAB7ACAAJABzAG8AdQByAGMAZQAgAD0AIAAkAHYAbwBpAGMAZQAuAFAAUwBQAGEAdABoADsAIABjAG8AcAB5ACAALQBQAGEAdABoACAAJABzAG8AdQByAGMAZQAgAC0ARABlAHMAdABpAG4AYQB0AGkAbwBuACAAJABkAGUAcwB0AGkAbgBhAHQAaQBvAG4AUABhAHQAaAAgAC0AUgBlAGMAdQByAHMAZQAgAH0A\" -Verb RunAs"
```

### Wait, how did you encode the powershell script?
```
X:\>powershell
PS X:\> $command = '$sourcePath = ''HKLM:\software\Microsoft\Speech_OneCore\Voices\Tokens''; $destinationPath = ''HKLM:\SOFTWARE\Microsoft\Speech\Voices\Tokens''; cd $destinationPath; $listVoices = Get-ChildItem $sourcePath; foreach($voice in $listVoices) { $source = $voice.PSPath; copy -Path $source -Destination $destinationPath -Recurse }'
PS X:\> echo $command
$sourcePath = 'HKLM:\software\Microsoft\Speech_OneCore\Voices\Tokens'; $destinationPath = 'HKLM:\SOFTWARE\Microsoft\Speech\Voices\Tokens'; cd $destinationPath; $listVoices = Get-ChildItem $sourcePath; foreach($voice in $listVoices) { $source = $voice.PSPath; copy -Path $source -Destination $destinationPath -Recurse }

PS X:\> $bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
PS X:\> echo $bytes
36
0
115
0
111
0
117
0
114
....

PS X:\> $encodedCommand = [Convert]::ToBase64String($bytes)
PS X:\> echo $encodedCommand
JABzAG8AdQByAGMAZQBQAGEAdABoACAAPQAgACcASABLAEwATQA6AFwAcwBvAGYAdAB3AGEAcgBlAFwATQBpAGMAcgBvAHMAbwBmAHQAXABTAHAAZQBlAGMAaABfAE8AbgBlAEMAbwByAGUAXABWAG8AaQBjAGUAcwBcAFQAbwBrAGUAbgBzACcAOwAgACQAZABlAHMAdABpAG4AYQB0AGkAbwBuAFAAYQB0AGgAIAA9ACAAJwBIAEsATABNADoAXABTAE8ARgBUAFcAQQBSAEUAXABNAGkAYwByAG8AcwBvAGYAdABcAFMAcABlAGUAYwBoAFwAVgBvAGkAYwBlAHMAXABUAG8AawBlAG4AcwAnADsAIABjAGQAIAAkAGQAZQBzAHQAaQBuAGEAdABpAG8AbgBQAGEAdABoADsAIAAkAGwAaQBzAHQAVgBvAGkAYwBlAHMAIAA9ACAARwBlAHQALQBDAGgAaQBsAGQASQB0AGUAbQAgACQAcwBvAHUAcgBjAGUAUABhAHQAaAA7ACAAZgBvAHIAZQBhAGMAaAAoACQAdgBvAGkAYwBlACAAaQBuACAAJABsAGkAcwB0AFYAbwBpAGMAZQBzACkAIAB7ACAAJABzAG8AdQByAGMAZQAgAD0AIAAkAHYAbwBpAGMAZQAuAFAAUwBQAGEAdABoADsAIABjAG8AcAB5ACAALQBQAGEAdABoACAAJABzAG8AdQByAGMAZQAgAC0ARABlAHMAdABpAG4AYQB0AGkAbwBuACAAJABkAGUAcwB0AGkAbgBhAHQAaQBvAG4AUABhAHQAaAAgAC0AUgBlAGMAdQByAHMAZQAgAH0A
```


## Credits
- https://stackoverflow.com/questions/55695930/listing-and-selecting-installed-voice-for-text-to-speech
- https://support.microsoft.com/en-us/topic/how-to-download-text-to-speech-languages-for-windows-10-d5a6b612-b3ae-423f-afa5-4f6caf1ec5d3
