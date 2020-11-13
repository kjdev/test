$ErrorActionPreference = "Stop"

echo ${env:PATH}

# $task = New-Item 'task.bat' -Force
# Add-Content $task 'call phpize 2>&1'
# Add-Content $task 'call configure --with-php-build=C:\build-cache\deps --enable-test --enable-debug-pack 2>&1'
# Add-Content $task 'nmake /nologo 2>&1'
# Add-Content $task 'exit %errorlevel%'
# & "C:\build-cache\php-sdk-$env:BIN_SDK_VER\phpsdk-$env:VC-$env:ARCH.bat" -t $task
# if (-not $?) {
#     throw "building failed with errorlevel $LastExitCode"
# }
phpize
configure --with-php-build=C:\build-cache\deps --enable-test --enable-debug-pack
nmake /nologo

$dname = ''
if ($env:ARCH -eq 'x64') {
    $dname += 'x64\'
}
$dname += 'Release';
if ($env:TS -eq '1') {
    $dname += '_TS'
}
Copy-Item "$dname\php_test.dll" "$env:PHP_PATH\ext\php_test.dll"
Copy-Item "$dname\php_test.dll" "php_test.dll"

$ini = New-Item "$env:PHP_PATH\php.ini" -Force
Add-Content $ini "extension_dir=$env:PHP_PATH\ext"
Add-Content $ini 'extension=php_openssl.dll'
Add-Content $ini 'extension=php_test.dll'
