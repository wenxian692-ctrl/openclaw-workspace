@echo off
setlocal enabledelayedexpansion
for /d %%d in (*) do (
  set "skip="
  if /i "%%d"=="." set skip=1
  if /i "%%d"==".." set skip=1
  if /i "%%d"==".openclaw" set skip=1
  if /i "%%d"=="memory" set skip=1
  if /i "%%d"=="node_modules" set skip=1
  if /i "%%d"=="skills" set skip=1
  if /i "%%d"=="extracted_docs" set skip=1
  if /i "%%d"=="extracted_docs_v2" set skip=1
  if /i "%%d"=="extracted_ref" set skip=1
  if not defined skip (
    for %%f in ("%%d") do echo %%~sf
  )
)