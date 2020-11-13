$ErrorActionPreference = "Stop"

$env:PHP_PATH = "C:\build-cache\php-7.4.12-nts-Win32-vc15-x64"

$env:TEST_PHP_EXECUTABLE = "$env:PHP_PATH\php.exe"
& $env:TEST_PHP_EXECUTABLE 'run-tests.php' --show-diff tests
if (-not $?) {
    throw "testing failed with errorlevel $LastExitCode"
}
