$ErrorActionPreference = "Stop"

$env:PATH = "C:\php\devel;C:\php\bin;C:\php\deps\bin;$env:PATH"

$task = New-Item 'task.bat' -Force
Add-Content $task 'call phpize 2>&1'
Add-Content $task 'call configure --with-php-build=C:\php\deps --enable-test --enable-debug-pack 2>&1'
Add-Content $task 'nmake /nologo 2>&1'
Add-Content $task 'exit %errorlevel%'
& "C:\php\php-sdk-$env:BIN_SDK_VER\phpsdk-$env:VC-$env:ARCH.bat" -t $task
if (-not $?) {
    throw "building failed with errorlevel $LastExitCode"
}

$dname = ''
if ($env:ARCH -eq 'x64') {
    $dname += 'x64\'
}
$dname += 'Release';
if ($env:TS -eq 'ts') {
    $dname += '_TS'
}
Copy-Item "$dname\php_test.dll" "C:\php\bin\ext\php_test.dll"
Copy-Item "$dname\php_test.dll" "php_test.dll"

$ini = New-Item "C:\php\bin\php.ini" -Force
Add-Content $ini "extension_dir=C:\php\bin\ext"
Add-Content $ini 'extension=php_openssl.dll'
Add-Content $ini 'extension=php_test.dll'
