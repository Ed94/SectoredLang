set YYYY=%date:~10,4%
set MM=%date:~4,2%
set DD=%date:~7,2%
set HH=%time:~0,2%
if %HH% lss 10 (set CUR_HH=0%time:~1,1%)
set NN=%time:~3,2%
set SS=%time:~6,2%
set MS=%time:~9,2%
set SUBFILENAME=%YYYY%%MM%%DD%%HH%%NN%%SS%

cd Builds
mkdir %SUBFILENAME%

cd ..\Engine\gd\bin
godot.windows.opt.64.exe --export "Windows Desktop" "..\Builds\%SUBFILENAME%\mas.exe" --path "..\..\..\App"