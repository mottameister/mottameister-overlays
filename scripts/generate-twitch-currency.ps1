Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$currencyDir = Join-Path $root "assets\twitch-currency\penas-de-coruja"
$sourcePath = Join-Path $currencyDir "source\pena.png"
$outDir = Join-Path $currencyDir "png"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

Add-Type -AssemblyName System.Drawing

if (-not (Test-Path -LiteralPath $sourcePath)) {
  throw "Source image not found: $sourcePath"
}

$source = [System.Drawing.Bitmap]::FromFile($sourcePath)
$threshold = 10
$minX = $source.Width
$minY = $source.Height
$maxX = 0
$maxY = 0

for ($y = 0; $y -lt $source.Height; $y++) {
  for ($x = 0; $x -lt $source.Width; $x++) {
    if ($source.GetPixel($x, $y).A -gt $threshold) {
      if ($x -lt $minX) { $minX = $x }
      if ($y -lt $minY) { $minY = $y }
      if ($x -gt $maxX) { $maxX = $x }
      if ($y -gt $maxY) { $maxY = $y }
    }
  }
}

if ($minX -gt $maxX -or $minY -gt $maxY) {
  $source.Dispose()
  throw "No visible pixels found in source image."
}

$contentWidth = $maxX - $minX + 1
$contentHeight = $maxY - $minY + 1
$side = [Math]::Max($contentWidth, $contentHeight)
$padding = [Math]::Ceiling($side * 0.07)
$side = $side + ($padding * 2)

$cropX = [Math]::Floor($minX + ($contentWidth / 2) - ($side / 2))
$cropY = [Math]::Floor($minY + ($contentHeight / 2) - ($side / 2))

$square = New-Object System.Drawing.Bitmap($side, $side, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$square.SetResolution($source.HorizontalResolution, $source.VerticalResolution)
$g = [System.Drawing.Graphics]::FromImage($square)
$g.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
$g.Clear([System.Drawing.Color]::Transparent)
$g.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceOver
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$destRect = New-Object System.Drawing.Rectangle((-$cropX), (-$cropY), $source.Width, $source.Height)
$g.DrawImage($source, $destRect)
$g.Dispose()

foreach ($size in 28, 56, 112) {
  $output = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $output.SetResolution(72, 72)
  $g2 = [System.Drawing.Graphics]::FromImage($output)
  $g2.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
  $g2.Clear([System.Drawing.Color]::Transparent)
  $g2.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceOver
  $g2.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g2.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $g2.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $g2.DrawImage($square, 0, 0, $size, $size)
  $g2.Dispose()
  $output.Save((Join-Path $outDir "penas-de-coruja-$size.png"), [System.Drawing.Imaging.ImageFormat]::Png)
  $output.Dispose()
}

$previewSize = 196
$preview = New-Object System.Drawing.Bitmap($previewSize, $previewSize, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$preview.SetResolution(72, 72)
$gp = [System.Drawing.Graphics]::FromImage($preview)
$gp.Clear([System.Drawing.Color]::FromArgb(255, 8, 10, 16))
$gp.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$img112 = [System.Drawing.Image]::FromFile((Join-Path $outDir "penas-de-coruja-112.png"))
$gp.DrawImage($img112, 42, 42, 112, 112)
$img112.Dispose()
$gp.Dispose()
$preview.Save((Join-Path $currencyDir "preview.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$preview.Dispose()

$square.Dispose()
$source.Dispose()

Write-Host "Generated Twitch currency assets at $currencyDir"
