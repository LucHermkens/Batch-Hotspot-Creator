@echo off

cd C:\Program Files\Hotspot

SET    abet=abcdefghijklmnopqrstuvwxyz!@#-/\ .0123456789
SET cipher1=8p#j4 9z\6w.ae@0u2r5o!xk-cf1b3g7hmqil/sntdvy
(
 FOR /f "delims=" %%a IN (password) DO (
  SET line=%%a
  CALL :encipher
 )
)>password_encrypted
(
 FOR /f "delims=" %%a IN (password_encrypted) DO (
  SET line=%%a
  CALL :decipher
 )
)>password_decrypted
GOTO :EOF
:decipher
SET morf=%abet%
SET from=%cipher1%
GOTO trans
:encipher
SET from=%abet%
SET morf=%cipher1%
:trans
SET "enil="
:transl
SET $1=%from%
SET $2=%morf%
:transc
IF /i "%line:~0,1%"=="%$1:~0,1%" SET enil=%enil%%$2:~0,1%&GOTO transnc
SET $1=%$1:~1%
SET $2=%$2:~1%
IF DEFINED $2 GOTO transc
SET enil=%enil%%line:~0,1%
:transnc
SET line=%line:~1%
IF DEFINED line GOTO transl
ECHO %enil%
GOTO :eof