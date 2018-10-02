REM build.bat

set R=R-3.5.1
set pckg=IDPmisc
set version=1.1.18

setlocal
path %path%;"C:\Program Files\R\%R%\bin\x64";"C:\Program Files\R\%R%\bin\i386"

@echo Removing outdated directories ------------------------------
if exist %pckg%.Rcheck rmdir %pckg%.Rcheck /S/Q
if exist %pckg%\src-x64 rmdir %pckg%\src-x64 /S/Q
if exist %pckg%\src-i386 rmdir %pckg%\src-i386 /S/Q

R CMD build --resave-data %pckg%
@if errorlevel 1 goto error

@echo ------------------------------------------------------------
@echo ------------------------------------------------------------
@echo Checking package -------------------------------------------
R CMD check --as-cran %pckg%_%version%.tar.gz
@if errorlevel 1 goto error

@echo Removing temporal directories ------------------------------
rmdir %pckg%\src-x64 /S/Q
rmdir %pckg%\src-i386 /S/Q

@echo ------------------------------------------------------------
@echo ------------------------------------------------------------
@echo Installing package -----------------------------------------
R CMD INSTALL --build %pckg%_%version%.tar.gz
@if errorlevel 1 goto error

@echo ------------------------------------------------------------
@echo ------------------------------------------------------------
@echo OK. Check log file for warnings!
@goto End

:error
@echo off
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo !!!!!!!!!!!!!! There exists at least one ERROR !!!!!!!!!!!!!
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

:End
@echo Removing temporal directories if existing-------------------
if exist %pckg%\src-x64 rmdir %pckg%\src-x64 /S/Q
if exist %pckg%\src-i386 rmdir %pckg%\src-i386 /S/Q

