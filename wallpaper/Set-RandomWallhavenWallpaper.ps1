function Set-RandomWallhavenWallpaper() {
    [CmdletBinding()]
    param ()

    $randomPage = (1..100 | random)
    $randomWallpaper = Get-WallhavenWallpaper -Search -Category General, Anime -Purity Sfw -Order desc -SearchSorting favorites -Ratios 16x10, 16x9 -PageNumber $randomPage | random
    $fileName = $randomWallpaper.FileName;
    $destinationPath = "D:\Wallheaven-Wallpaper\$fileName"
    
    if ((Test-Path $destinationPath) -eq $false) {
        Write-Debug "Path not found: $destinationPath. Downloading file..."
        Invoke-WebRequest -Uri $randomWallpaper.Source -OutFile $destinationPath
    }
    
    Write-Debug "Setting new random wallpaper to path: $destinationPath"
    Set-Wallpaper -Path $destinationPath
}