:: This batch script unlocks the Microsoft Windows TTS voices for use
:: with other x64 applications such as PowerShell.
:: Feel free to bundle this script with your application.
:: Please do not remove this comment.
::
::     Copyright 2021 Johann N. Loefflmann
::
:: Licensed under the Apache License, Version 2.0 (the "License");
:: you may not use this file except in compliance with the License.
:: You may obtain a copy of the License at
::
::     http://www.apache.org/licenses/LICENSE-2.0
::
:: Unless required by applicable law or agreed to in writing, software
:: distributed under the License is distributed on an "AS IS" BASIS,
:: WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
:: See the License for the specific language governing permissions and
:: limitations under the License.

@echo off
goto run

:check
echo For now powershell sees the following TTS voices:
powershell -Command "Add-Type -AssemblyName System.Speech; $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer; $speak.GetInstalledVoices() | Select-Object -ExpandProperty VoiceInfo | Select-Object -Property Name, Culture, Gender, Age, Description | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1"
exit /b

:enable
echo Unlocking TTS voices ...
powershell.exe -Command "Start-Process -WindowStyle Hidden -FilePath powershell.exe -ArgumentList \"-ExecutionPolicy Unrestricted -EncodedCommand JABzAG8AdQByAGMAZQBQAGEAdABoACAAPQAgACcASABLAEwATQA6AFwAcwBvAGYAdAB3AGEAcgBlAFwATQBpAGMAcgBvAHMAbwBmAHQAXABTAHAAZQBlAGMAaABfAE8AbgBlAEMAbwByAGUAXABWAG8AaQBjAGUAcwBcAFQAbwBrAGUAbgBzACcAOwAgACQAZABlAHMAdABpAG4AYQB0AGkAbwBuAFAAYQB0AGgAIAA9ACAAJwBIAEsATABNADoAXABTAE8ARgBUAFcAQQBSAEUAXABNAGkAYwByAG8AcwBvAGYAdABcAFMAcABlAGUAYwBoAFwAVgBvAGkAYwBlAHMAXABUAG8AawBlAG4AcwAnADsAIABjAGQAIAAkAGQAZQBzAHQAaQBuAGEAdABpAG8AbgBQAGEAdABoADsAIAAkAGwAaQBzAHQAVgBvAGkAYwBlAHMAIAA9ACAARwBlAHQALQBDAGgAaQBsAGQASQB0AGUAbQAgACQAcwBvAHUAcgBjAGUAUABhAHQAaAA7ACAAZgBvAHIAZQBhAGMAaAAoACQAdgBvAGkAYwBlACAAaQBuACAAJABsAGkAcwB0AFYAbwBpAGMAZQBzACkAIAB7ACAAJABzAG8AdQByAGMAZQAgAD0AIAAkAHYAbwBpAGMAZQAuAFAAUwBQAGEAdABoADsAIABjAG8AcAB5ACAALQBQAGEAdABoACAAJABzAG8AdQByAGMAZQAgAC0ARABlAHMAdABpAG4AYQB0AGkAbwBuACAAJABkAGUAcwB0AGkAbgBhAHQAaQBvAG4AUABhAHQAaAAgAC0AUgBlAGMAdQByAHMAZQAgAH0A\" -Verb RunAs"
exit /b

:run
call :check
set "reply=y"
set /p "reply=Unlocking TTS voices? [y]: "
if /i not "%reply%" == "y" goto :end
call :enable
call :check
echo Done.
pause
:end
