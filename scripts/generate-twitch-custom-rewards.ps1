Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$rewardDir = Join-Path $root "assets\twitch-custom-rewards"
$pngDir = Join-Path $rewardDir "png"
New-Item -ItemType Directory -Force -Path $pngDir | Out-Null

Add-Type -AssemblyName System.Drawing

$Palette = @{
  Transparent = [System.Drawing.Color]::FromArgb(0, 0, 0, 0)
  Background  = [System.Drawing.Color]::FromArgb(255, 14, 10, 9)
  Border      = [System.Drawing.Color]::FromArgb(255, 96, 56, 18)
  Gold        = [System.Drawing.Color]::FromArgb(255, 255, 194, 54)
  Amber       = [System.Drawing.Color]::FromArgb(255, 235, 121, 24)
  Orange      = [System.Drawing.Color]::FromArgb(255, 186, 72, 14)
  Dark        = [System.Drawing.Color]::FromArgb(255, 73, 28, 8)
  Light       = [System.Drawing.Color]::FromArgb(255, 255, 238, 145)
  Cyan        = [System.Drawing.Color]::FromArgb(255, 73, 238, 255)
  Magenta     = [System.Drawing.Color]::FromArgb(255, 218, 69, 255)
  Violet      = [System.Drawing.Color]::FromArgb(255, 126, 82, 255)
}

$Rewards = @(
  @{ Slug = "nickname-monstro"; Title = "Nickname em monstro"; Icon = "nickname" },
  @{ Slug = "escolher-time"; Title = "Escolher time"; Icon = "team" },
  @{ Slug = "lutar-so-inseto"; Title = "Lutar so inseto"; Icon = "bug" },
  @{ Slug = "esfera-rara-aleatoria"; Title = "Gastar esfera rara"; Icon = "rare-orb" },
  @{ Slug = "capturar-brilhante"; Title = "Capturar brilhante"; Icon = "shiny-catch" },
  @{ Slug = "trocar-companheiro"; Title = "Trocar companheiro"; Icon = "swap" }
)

function New-Brush($color) {
  New-Object System.Drawing.SolidBrush($color)
}

function Fill-Pixel($g, $x, $y, $w, $h, $color) {
  $brush = New-Brush $color
  $g.FillRectangle($brush, $x, $y, $w, $h)
  $brush.Dispose()
}

function Draw-PixelLine($g, $x1, $y1, $x2, $y2, $color) {
  $pen = New-Object System.Drawing.Pen($color, 1)
  $g.DrawLine($pen, $x1, $y1, $x2, $y2)
  $pen.Dispose()
}

function Draw-Frame($g) {
  Fill-Pixel $g 3 3 22 22 $Palette.Background
  Fill-Pixel $g 4 2 20 1 $Palette.Border
  Fill-Pixel $g 4 25 20 1 $Palette.Border
  Fill-Pixel $g 2 4 1 20 $Palette.Border
  Fill-Pixel $g 25 4 1 20 $Palette.Border
  Fill-Pixel $g 5 4 6 1 $Palette.Gold
  Fill-Pixel $g 17 24 6 1 $Palette.Amber
}

function Draw-Spark($g, $x, $y, $color) {
  Fill-Pixel $g $x ($y - 2) 1 5 $color
  Fill-Pixel $g ($x - 2) $y 5 1 $color
  Fill-Pixel $g ($x - 1) ($y - 1) 3 3 $Palette.Light
}

function Draw-Capsule($g, $x, $y, $colorA, $colorB) {
  Fill-Pixel $g ($x + 2) $y 8 1 $Palette.Dark
  Fill-Pixel $g ($x + 1) ($y + 1) 10 1 $Palette.Dark
  Fill-Pixel $g $x ($y + 2) 12 5 $Palette.Dark
  Fill-Pixel $g ($x + 1) ($y + 7) 10 1 $Palette.Dark
  Fill-Pixel $g ($x + 2) ($y + 8) 8 1 $Palette.Dark
  Fill-Pixel $g ($x + 2) ($y + 2) 8 2 $colorA
  Fill-Pixel $g ($x + 1) ($y + 4) 10 1 $Palette.Light
  Fill-Pixel $g ($x + 2) ($y + 5) 8 2 $colorB
  Fill-Pixel $g ($x + 5) ($y + 3) 2 3 $Palette.Light
}

function Draw-Token($g, $x, $y, $color) {
  Fill-Pixel $g ($x + 2) $y 5 1 $Palette.Dark
  Fill-Pixel $g ($x + 1) ($y + 1) 7 1 $Palette.Dark
  Fill-Pixel $g $x ($y + 2) 9 5 $Palette.Dark
  Fill-Pixel $g ($x + 1) ($y + 7) 7 1 $Palette.Dark
  Fill-Pixel $g ($x + 2) ($y + 8) 5 1 $Palette.Dark
  Fill-Pixel $g ($x + 2) ($y + 2) 5 5 $color
  Fill-Pixel $g ($x + 4) ($y + 4) 1 1 $Palette.Light
}

function Draw-Icon($g, $icon) {
  Draw-Frame $g

  switch ($icon) {
    "nickname" {
      Fill-Pixel $g 7 8 13 10 $Palette.Dark
      Fill-Pixel $g 8 7 11 1 $Palette.Gold
      Fill-Pixel $g 8 18 11 1 $Palette.Orange
      Fill-Pixel $g 7 9 1 8 $Palette.Orange
      Fill-Pixel $g 20 9 1 8 $Palette.Orange
      Fill-Pixel $g 10 10 1 5 $Palette.Light
      Fill-Pixel $g 12 10 1 4 $Palette.Gold
      Fill-Pixel $g 14 10 1 5 $Palette.Light
      Fill-Pixel $g 16 10 1 4 $Palette.Gold
      Fill-Pixel $g 9 20 8 2 $Palette.Cyan
      Draw-Spark $g 22 8 $Palette.Magenta
    }
    "team" {
      Draw-Token $g 5 6 $Palette.Cyan
      Draw-Token $g 14 6 $Palette.Magenta
      Draw-Token $g 9 15 $Palette.Gold
      Draw-PixelLine $g 10 15 13 12 $Palette.Light
      Draw-PixelLine $g 15 15 13 12 $Palette.Light
    }
    "bug" {
      Fill-Pixel $g 12 7 4 2 $Palette.Gold
      Fill-Pixel $g 10 9 8 8 $Palette.Dark
      Fill-Pixel $g 11 10 6 6 $Palette.Orange
      Fill-Pixel $g 12 11 4 4 $Palette.Gold
      Fill-Pixel $g 9 8 2 1 $Palette.Light
      Fill-Pixel $g 17 8 2 1 $Palette.Light
      Draw-PixelLine $g 8 12 4 10 $Palette.Cyan
      Draw-PixelLine $g 8 14 4 15 $Palette.Cyan
      Draw-PixelLine $g 20 12 24 10 $Palette.Cyan
      Draw-PixelLine $g 20 14 24 15 $Palette.Cyan
      Draw-PixelLine $g 10 17 7 21 $Palette.Magenta
      Draw-PixelLine $g 18 17 21 21 $Palette.Magenta
    }
    "rare-orb" {
      Fill-Pixel $g 9 7 10 1 $Palette.Dark
      Fill-Pixel $g 7 9 14 2 $Palette.Dark
      Fill-Pixel $g 6 11 16 7 $Palette.Dark
      Fill-Pixel $g 8 18 12 2 $Palette.Dark
      Fill-Pixel $g 10 20 8 1 $Palette.Dark
      Fill-Pixel $g 9 10 10 3 $Palette.Magenta
      Fill-Pixel $g 8 13 12 2 $Palette.Violet
      Fill-Pixel $g 9 15 10 3 $Palette.Cyan
      Fill-Pixel $g 12 11 3 6 $Palette.Light
      Draw-Spark $g 22 7 $Palette.Gold
    }
    "shiny-catch" {
      Draw-Capsule $g 8 14 $Palette.Cyan $Palette.Violet
      Draw-Spark $g 9 8 $Palette.Gold
      Draw-Spark $g 20 10 $Palette.Magenta
      Fill-Pixel $g 16 5 1 4 $Palette.Cyan
      Fill-Pixel $g 14 7 5 1 $Palette.Cyan
    }
    "swap" {
      Draw-Token $g 5 7 $Palette.Cyan
      Draw-Token $g 14 13 $Palette.Magenta
      Draw-PixelLine $g 12 9 21 9 $Palette.Gold
      Draw-PixelLine $g 21 9 18 6 $Palette.Gold
      Draw-PixelLine $g 21 9 18 12 $Palette.Gold
      Draw-PixelLine $g 16 21 7 21 $Palette.Light
      Draw-PixelLine $g 7 21 10 18 $Palette.Light
      Draw-PixelLine $g 7 21 10 24 $Palette.Light
    }
  }
}

function Export-Icon($reward, $size) {
  $base = New-Object System.Drawing.Bitmap(28, 28, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($base)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::None
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
  $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
  $g.Clear($Palette.Transparent)
  Draw-Icon $g $reward.Icon
  $g.Dispose()

  $output = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g2 = [System.Drawing.Graphics]::FromImage($output)
  $g2.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
  $g2.Clear($Palette.Transparent)
  $g2.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceOver
  $g2.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
  $g2.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::None
  $g2.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
  $g2.DrawImage($base, 0, 0, $size, $size)
  $g2.Dispose()
  $output.Save((Join-Path $pngDir "$($reward.Slug)-$size.png"), [System.Drawing.Imaging.ImageFormat]::Png)
  $output.Dispose()
  $base.Dispose()
}

foreach ($reward in $Rewards) {
  foreach ($size in 28, 56, 112) {
    Export-Icon $reward $size
  }
}

$previewWidth = 820
$previewHeight = 480
$preview = New-Object System.Drawing.Bitmap($previewWidth, $previewHeight, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$gp = [System.Drawing.Graphics]::FromImage($preview)
$gp.Clear([System.Drawing.Color]::FromArgb(255, 8, 10, 16))
$gp.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$font = New-Object System.Drawing.Font("Segoe UI Semibold", 14, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
$small = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
$label = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(245, 247, 251, 255))
$muted = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(245, 140, 148, 168))

$y = 28
foreach ($reward in $Rewards) {
  $img112 = [System.Drawing.Image]::FromFile((Join-Path $pngDir "$($reward.Slug)-112.png"))
  $img56 = [System.Drawing.Image]::FromFile((Join-Path $pngDir "$($reward.Slug)-56.png"))
  $img28 = [System.Drawing.Image]::FromFile((Join-Path $pngDir "$($reward.Slug)-28.png"))
  $gp.DrawImage($img112, 28, $y, 56, 56)
  $gp.DrawImage($img56, 105, ($y + 14), 28, 28)
  $gp.DrawImage($img28, 151, ($y + 21), 14, 14)
  $gp.DrawString($reward.Title, $font, $label, 190, ($y + 10))
  $gp.DrawString("$($reward.Slug)-28/56/112.png", $small, $muted, 190, ($y + 32))
  $img112.Dispose()
  $img56.Dispose()
  $img28.Dispose()
  $y += 72
}

$preview.Save((Join-Path $rewardDir "preview.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$font.Dispose()
$small.Dispose()
$label.Dispose()
$muted.Dispose()
$gp.Dispose()
$preview.Dispose()

Write-Host "Generated Twitch custom reward icons at $rewardDir"
