@echo off
rem Türkçe araçlar eklentisini Praat'ın tercih klasörüne (%APPDATA%\Praat) kopyalar.
rem Praat.exe ile aynı klasörden çift tıklayarak çalıştırın. Sonra Praat'ı yeniden açın.
chcp 65001 >nul
xcopy /E /I /Y "%~dp0plugin_TurkceAraclar" "%APPDATA%\Praat\plugin_TurkceAraclar" >nul
if errorlevel 1 (
  echo Kopyalanamadi: %APPDATA%\Praat\plugin_TurkceAraclar
) else (
  echo Kuruldu: %APPDATA%\Praat\plugin_TurkceAraclar
)
pause
