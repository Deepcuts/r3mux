@ECHO OFF
CD ../Completed
for %%f in (*) do (
  md "%%~nf"
  move "%%f" "%%~nf"
) >nul 2>&1