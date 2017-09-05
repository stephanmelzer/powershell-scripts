function Set-Wallpaper() {
    Param(
        [Parameter(Mandatory = $true)]
        [string]
        $Path,
        [ValidateSet("Tile", "Center", "Stretch", "Fit", "Fill")]
        [string]
        $Style = "Fill",
        [switch]
        $Random
    )

    if ($Random) {
        if ((Get-Item $Path).PSIsContainer -eq $false) {
            Write-Warning "$Path is not a directory! Setting file as new wallpaper..."
        }

        $Path = (Get-ChildItem -Recurse:$Recurse $Path -File | Where-Object { $_.Extension -in @(".jpg", ".png", ".bmp") } | Get-Random).FullName
    }

    $SPI_SETDESKWALLPAPER = 0x14
    $SPIF_UPDATEINIFILE = 0x1
    $MethodDefinition = @"
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern Int32 SystemParametersInfo(UInt32 uiAction, UInt32 uiParam, String pvParam, UInt32 fWinIni);
"@

    switch ($Style) {
        "Tile" { 
            $wallpaperStyle = 0
            $tile = 1
        }
        "Center" { 
            $wallpaperStyle = 0
            $tile = 0
        }
        "Stretch" { 
            $wallpaperStyle = 2
            $tile = 0
        }
        "Fit" { 
            $wallpaperStyle = 6
            $tile = 0
        }
        "Fill" { 
            $wallpaperStyle = 10
            $tile = 0       
        }
    }

    $registryPath = "HKCU:\Control Panel\Desktop"
    Set-ItemProperty -Path $registryPath -Name WallpaperStyle -Value $wallpaperStyle
    Set-ItemProperty -Path $registryPath -Name TileWallpaper -Value $tile

    $User32 = Add-Type -MemberDefinition $MethodDefinition -Name 'User32' -Namespace 'Win32Functions' -PassThru
    [void]$User32::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $Path, $SPIF_UPDATEINIFILE)
}