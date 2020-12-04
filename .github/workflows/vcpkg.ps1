$ErrorActionPreference = "Stop"

if ($env:VCPKG -eq '1' -and -not (Test-Path 'C:\php\deps')) {
    [void](New-Item 'C:\php\deps' -ItemType 'directory')

    vcpkg install "snappy:$env:ARCH-windows"
    if (-not $?) {
        throw "installing failed with errorlevel $LastExitCode"
    }

    ls C:\vcpkg\installed

    Copy-Item "C:\vcpkg\installed\$env:ARCH-windows\bin" "C:\php\deps" -Recurse -Force
    Copy-Item "C:\vcpkg\installed\$env:ARCH-windows\include" "C:\php\deps" -Recurse -Force
    Copy-Item "C:\vcpkg\installed\$env:ARCH-windows\lib" "C:\php\deps" -Recurse -Force
}
