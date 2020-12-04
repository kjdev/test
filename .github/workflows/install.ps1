$ErrorActionPreference = "Stop"

if (-not (Test-Path 'C:\php')) {
    [void](New-Item 'C:\php' -ItemType 'directory')
}

# PHP SDK
$bname = "php-sdk-$env:BIN_SDK_VER.zip"
if (-not (Test-Path C:\php\$bname)) {
    Invoke-WebRequest "https://github.com/microsoft/php-sdk-binary-tools/archive/$bname" -OutFile "C:\php\$bname"
}
$dname0 = "php-sdk-binary-tools-php-sdk-$env:BIN_SDK_VER"
$dname1 = "php-sdk-$env:BIN_SDK_VER"
if (-not (Test-Path "C:\php\$dname1")) {
    Expand-Archive "C:\php\$bname" "C:\php"
    Move-Item "C:\php\$dname0" "C:\php\$dname1"
}

# PHP releases
Invoke-WebRequest "https://windows.php.net/downloads/releases/releases.json" -OutFile "C:\php\releases.json"
$php_version = (Get-Content -Path "C:\php\releases.json" | ConvertFrom-Json | ForEach-Object {
    if ($_."$env:PHP_VER") {
        return $_."$env:PHP_VER".version
    } else {
        return "$env:PHP_VER"
    }
})

# PHP devel pack
$ts_part = ''
if ('0' -eq $env:TS) {
    $ts_part = '-nts'
}
$bname = "php-devel-pack-$php_version$ts_part-Win32-$env:VC-$env:ARCH.zip"
if (-not (Test-Path "C:\php\$bname")) {
    try {
        Invoke-WebRequest "https://windows.php.net/downloads/releases/$bname" -OutFile "C:\php\$bname"
    } catch [System.Net.WebException] {
        Invoke-WebRequest "https://windows.php.net/downloads/releases/archives/$bname" -OutFile "C:\php\$bname"
    }
}
$dname0 = "php-$php_version-devel-$env:VC-$env:ARCH"
# $dname1 = "php-$php_version$ts_part-devel-$env:VC-$env:ARCH"
# if (-not (Test-Path "C:\php\$dname1")) {
if (-not (Test-Path "C:\php\devel")) {
    Expand-Archive "C:\php\$bname" 'C:\php'
    if (-not (Test-Path "C:\php\$dname0")) {
        $php_normalize_version = $php_version.Split("-")[0]
        $dname0 = "php-$php_normalize_version-devel-$env:VC-$env:ARCH"
    }
#    if ($dname0 -ne $dname1) {
#        Move-Item "C:\php\$dname0" "C:\php\$dname1"
    if (-not (Test-Path "C:\php\devel")) {
        Move-Item "C:\php\$dname0" "C:\php\devel"
    }
}
# $env:PATH = "C:\php\$dname1;$env:PATH"
$env:PATH = "C:\php\devel;$env:PATH"

# PHP binary
$bname = "php-$php_version$ts_part-Win32-$env:VC-$env:ARCH.zip"
if (-not (Test-Path "C:\php\$bname")) {
    try {
        Invoke-WebRequest "https://windows.php.net/downloads/releases/$bname" -OutFile "C:\php\$bname"
    } catch [System.Net.WebException] {
        Invoke-WebRequest "https://windows.php.net/downloads/releases/archives/$bname" -OutFile "C:\php\$bname"
    }
}
# $dname = "php-$php_version$ts_part-Win32-$env:VC-$env:ARCH"
# if (-not (Test-Path "C:\php\$dname")) {
if (-not (Test-Path "C:\php\bin")) {
#    Expand-Archive "C:\php\$bname" "C:\php\$dname"
    Expand-Archive "C:\php\$bname" "C:\php\bin"
}
# $env:PHP_PATH = "C:\php\$dname"
$env:PHP_PATH = "C:\php\bin"
$env:PATH = "$env:PHP_PATH;$env:PATH"

# # library dependency
# $bname = "$env:DEP-$env:VC-$env:ARCH.zip"
# if (-not (Test-Path "C:\php\$bname")) {
#     Invoke-WebRequest "https://windows.php.net/downloads/pecl/deps/$bname" -OutFile "C:\php\$bname"
#     Expand-Archive "C:\php\$bname" 'C:\php\deps'
# }
$env:PATH = "C:\php\deps\bin;$env:PATH"

echo "PATH:" $env:PATH


ls "C:\php\devel"

ls "C:\php\bin"
