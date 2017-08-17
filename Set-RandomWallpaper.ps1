function Set-RandomWallpaper () {
    Param(
        [Parameter(Mandatory = $true)]
        [string]
        $Path,
        [ValidateSet("Tile", "Center", "Stretch", "Fit", "Fill")]
        [string]
        $Style = "Fill"
    )
    $randomWallpaperPath = (Get-ChildItem  $Path -File | Where-Object { $_.Extension -in @(".jpg", ".png", ".bmp") } | Get-Random).FullName
    Set-Wallpaper -Path $randomWallpaperPath -Style $Style
}