# zip-upm-packages.ps1 - .tgz archives with 'package' root folder inside the archive

# Packages to archive
$packages = @(
    "com.unity.render-pipelines.core",
    "com.unity.render-pipelines.universal"
	"com.unity.shadergraph"
)

# Output directory for tarballs (creates "Zipped" folder inside current directory)
$outputDir = Join-Path -Path (Get-Location) -ChildPath "Zipped"
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

foreach ($pkg in $packages) {
    $pkgPath = Join-Path -Path (Get-Location) -ChildPath $pkg
    $tgzPath = Join-Path -Path $outputDir -ChildPath "$pkg.tgz"

    if (Test-Path $pkgPath) {
        Write-Host "Creating tarball: $pkg.tgz"

        # Create a temporary folder to stage files inside 'package' folder
        $tempDir = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ([System.Guid]::NewGuid().ToString())
        $packageRoot = Join-Path -Path $tempDir -ChildPath "package"
        New-Item -ItemType Directory -Path $packageRoot -Force | Out-Null

        # Copy the package contents into the 'package' folder
        Copy-Item -Path (Join-Path $pkgPath '*') -Destination $packageRoot -Recurse -Force

        # Change to the temp folder (which contains 'package' folder)
        Push-Location $tempDir

        # Create the .tgz archive including the 'package' folder at root
        tar -czf $tgzPath "package"

        Pop-Location

        # Clean up temporary folder
        Remove-Item -LiteralPath $tempDir -Recurse -Force

        Write-Host "Created: $tgzPath`n"
    } else {
        Write-Warning "Package folder not found: $pkgPath"
    }
}

Write-Host "All done! Tarballs are in: $outputDir"
