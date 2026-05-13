Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$rewardDir = Join-Path $root "assets\twitch-rewards"
$pngDir = Join-Path $rewardDir "png"
New-Item -ItemType Directory -Force -Path $pngDir | Out-Null

Add-Type -AssemblyName System.Drawing

$Palette = @{
  Background = "#080A10"
  Panel      = "#151A28"
  Cyan       = "#39F5FF"
  Magenta    = "#C13CFF"
  Violet     = "#7B4DFF"
  White      = "#F7FBFF"
  Muted      = "#657086"
}

$Rewards = @(
  @{ Slug = "destacar-mensagem"; Title = "Destacar mensagem"; Icon = "highlight"; Accent = $Palette.Cyan; Accent2 = $Palette.Magenta },
  @{ Slug = "emote-inscrito-aleatorio"; Title = "Emote inscrito aleatorio"; Icon = "random"; Accent = $Palette.Magenta; Accent2 = $Palette.Cyan },
  @{ Slug = "mensagem-inscritos"; Title = "Mensagem para inscritos"; Icon = "pencil"; Accent = $Palette.Violet; Accent2 = $Palette.Cyan },
  @{ Slug = "escolher-emote"; Title = "Escolher emote"; Icon = "choose"; Accent = $Palette.Cyan; Accent2 = $Palette.Magenta },
  @{ Slug = "modificar-emote"; Title = "Modificar emote"; Icon = "modify"; Accent = $Palette.Magenta; Accent2 = $Palette.Violet }
)

function Convert-HexColor($hex) {
  $value = $hex.TrimStart("#")
  [System.Drawing.Color]::FromArgb(
    [Convert]::ToInt32($value.Substring(0, 2), 16),
    [Convert]::ToInt32($value.Substring(2, 2), 16),
    [Convert]::ToInt32($value.Substring(4, 2), 16)
  )
}

function New-Pen($hex, $width = 1, $alpha = 255) {
  $base = Convert-HexColor $hex
  $color = [System.Drawing.Color]::FromArgb($alpha, $base.R, $base.G, $base.B)
  New-Object System.Drawing.Pen($color, $width)
}

function New-Brush($hex, $alpha = 255) {
  $base = Convert-HexColor $hex
  $color = [System.Drawing.Color]::FromArgb($alpha, $base.R, $base.G, $base.B)
  New-Object System.Drawing.SolidBrush($color)
}

function Draw-RoundedRect($g, $brush, $pen, $x, $y, $w, $h, $r) {
  $path = New-Object System.Drawing.Drawing2D.GraphicsPath
  $d = $r * 2
  $path.AddArc($x, $y, $d, $d, 180, 90)
  $path.AddArc($x + $w - $d, $y, $d, $d, 270, 90)
  $path.AddArc($x + $w - $d, $y + $h - $d, $d, $d, 0, 90)
  $path.AddArc($x, $y + $h - $d, $d, $d, 90, 90)
  $path.CloseFigure()
  if ($brush) { $g.FillPath($brush, $path) }
  if ($pen) { $g.DrawPath($pen, $path) }
  $path.Dispose()
}

function Draw-Base($g, $accent, $accent2) {
  $bg = New-Brush $Palette.Background 0
  $panel = New-Brush $Palette.Panel 235
  $border = New-Pen $accent 5 235
  $line = New-Pen $accent2 4 210
  $shadow = New-Pen "#05070D" 8 200

  $g.FillRectangle($bg, 0, 0, 112, 112)
  Draw-RoundedRect $g $panel $shadow 10 10 92 92 18
  Draw-RoundedRect $g $null $border 10 10 92 92 18
  $g.DrawLine($line, 23, 22, 45, 22)
  $g.DrawLine($line, 78, 90, 93, 90)

  $bg.Dispose()
  $panel.Dispose()
  $border.Dispose()
  $line.Dispose()
  $shadow.Dispose()
}

function Draw-RewardIcon($g, $icon, $accent, $accent2) {
  Draw-Base $g $accent $accent2
  $a = New-Pen $accent 7 255
  $b = New-Pen $accent2 6 245
  $w = New-Pen $Palette.White 6 245
  $thin = New-Pen $Palette.White 4 230
  $fillA = New-Brush $accent 72
  $fillB = New-Brush $accent2 85
  $dark = New-Pen "#05070D" 10 210

  switch ($icon) {
    "highlight" {
      Draw-RoundedRect $g $fillA $a 27 33 54 34 9
      $g.DrawLine($b, 41, 67, 34, 80)
      $g.DrawLine($thin, 39, 47, 66, 47)
      $g.DrawLine($thin, 39, 56, 57, 56)
      $g.DrawLine($w, 82, 25, 82, 36)
      $g.DrawLine($w, 76, 31, 88, 31)
    }
    "random" {
      Draw-RoundedRect $g $fillB $b 26 28 60 60 13
      $dot = New-Brush $Palette.White 245
      foreach ($p in @(@(42,43), @(70,43), @(56,56), @(42,70), @(70,70))) {
        $g.FillEllipse($dot, $p[0] - 4, $p[1] - 4, 8, 8)
      }
      $g.DrawLine($a, 29, 82, 82, 29)
      $g.DrawLine($a, 73, 29, 82, 29)
      $g.DrawLine($a, 82, 29, 82, 38)
      $dot.Dispose()
    }
    "pencil" {
      $points = @(
        [System.Drawing.PointF]::new(31, 75),
        [System.Drawing.PointF]::new(39, 54),
        [System.Drawing.PointF]::new(67, 26),
        [System.Drawing.PointF]::new(85, 44),
        [System.Drawing.PointF]::new(57, 72)
      )
      $g.DrawPolygon($dark, $points)
      $g.DrawPolygon($a, $points)
      $g.DrawLine($b, 67, 26, 85, 44)
      $g.DrawLine($thin, 40, 72, 31, 75)
      $g.DrawLine($thin, 42, 58, 56, 72)
    }
    "choose" {
      Draw-RoundedRect $g $fillA $a 24 27 64 54 12
      $smile = New-Pen $Palette.White 5 245
      $g.FillEllipse((New-Brush $Palette.White 245), 40, 44, 7, 7)
      $g.FillEllipse((New-Brush $Palette.White 245), 65, 44, 7, 7)
      $g.DrawArc($smile, 42, 50, 28, 18, 20, 140)
      $g.DrawLine($b, 76, 25, 88, 13)
      $g.DrawLine($b, 88, 13, 94, 23)
      $smile.Dispose()
    }
    "modify" {
      $g.DrawEllipse($a, 31, 28, 50, 50)
      $g.FillEllipse((New-Brush $Palette.White 245), 45, 45, 7, 7)
      $g.FillEllipse((New-Brush $Palette.White 245), 62, 45, 7, 7)
      $g.DrawArc($thin, 44, 53, 25, 14, 20, 140)
      $g.DrawLine($b, 22, 86, 90, 86)
      $g.DrawLine($b, 39, 81, 39, 91)
      $g.DrawLine($a, 22, 23, 90, 23)
      $g.DrawLine($a, 73, 18, 73, 28)
    }
  }

  $a.Dispose()
  $b.Dispose()
  $w.Dispose()
  $thin.Dispose()
  $fillA.Dispose()
  $fillB.Dispose()
  $dark.Dispose()
}

function Export-Reward($reward, $size) {
  $canvas = New-Object System.Drawing.Bitmap(112, 112, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($canvas)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  $g.Clear([System.Drawing.Color]::Transparent)
  Draw-RewardIcon $g $reward.Icon $reward.Accent $reward.Accent2
  $g.Dispose()

  $output = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g2 = [System.Drawing.Graphics]::FromImage($output)
  $g2.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
  $g2.Clear([System.Drawing.Color]::Transparent)
  $g2.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceOver
  $g2.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g2.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $g2.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $g2.DrawImage($canvas, 0, 0, $size, $size)
  $g2.Dispose()
  $output.Save((Join-Path $pngDir "$($reward.Slug)-$size.png"), [System.Drawing.Imaging.ImageFormat]::Png)
  $output.Dispose()
  $canvas.Dispose()
}

foreach ($reward in $Rewards) {
  foreach ($size in 28, 56, 112) {
    Export-Reward $reward $size
  }
}

$previewWidth = 760
$previewHeight = 420
$preview = New-Object System.Drawing.Bitmap($previewWidth, $previewHeight, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$gp = [System.Drawing.Graphics]::FromImage($preview)
$gp.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$gp.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$gp.Clear((Convert-HexColor $Palette.Background))
$font = New-Object System.Drawing.Font("Segoe UI Semibold", 14, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
$small = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
$label = New-Brush $Palette.White 245
$muted = New-Brush $Palette.Muted 245

$y = 28
foreach ($reward in $Rewards) {
  $img112 = [System.Drawing.Image]::FromFile((Join-Path $pngDir "$($reward.Slug)-112.png"))
  $img56 = [System.Drawing.Image]::FromFile((Join-Path $pngDir "$($reward.Slug)-56.png"))
  $img28 = [System.Drawing.Image]::FromFile((Join-Path $pngDir "$($reward.Slug)-28.png"))
  $gp.DrawImage($img112, 28, $y, 56, 56)
  $gp.DrawImage($img56, 105, ($y + 14), 28, 28)
  $gp.DrawImage($img28, 151, ($y + 21), 14, 14)
  $gp.DrawString($reward.Title, $font, $label, 190, ($y + 11))
  $gp.DrawString("$($reward.Slug)-28/56/112.png", $small, $muted, 190, ($y + 33))
  $img112.Dispose()
  $img56.Dispose()
  $img28.Dispose()
  $y += 76
}

$preview.Save((Join-Path $rewardDir "preview.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$font.Dispose()
$small.Dispose()
$label.Dispose()
$muted.Dispose()
$gp.Dispose()
$preview.Dispose()

Write-Host "Generated Twitch reward icons at $rewardDir"
