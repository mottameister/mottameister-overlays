Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$outDir = Join-Path $root "assets\twitch-panels"
$pngDir = Join-Path $outDir "png"
$svgDir = Join-Path $outDir "svg"
New-Item -ItemType Directory -Force -Path $pngDir, $svgDir | Out-Null

Add-Type -AssemblyName System.Drawing

$Width = 320
$Height = 80
$Scale = 2
$FontTitle = "Segoe UI Black"
$FontSmall = "Segoe UI Semibold"

$Palette = @{
  Background = "#080A10"
  Panel      = "#111622"
  Panel2     = "#1A2233"
  Cyan       = "#39F5FF"
  Magenta    = "#C13CFF"
  Violet     = "#7B4DFF"
  White      = "#F7FBFF"
  Muted      = "#5B6476"
}

$Panels = @(
  @{ Slug = "sobre";   Title = "SOBRE";   Icon = "user";    Accent = $Palette.Cyan;    Accent2 = $Palette.Magenta },
  @{ Slug = "discord"; Title = "DISCORD"; Icon = "chat";    Accent = $Palette.Violet;  Accent2 = $Palette.Cyan },
  @{ Slug = "redes";   Title = "REDES";   Icon = "nodes";   Accent = $Palette.Magenta; Accent2 = $Palette.Cyan },
  @{ Slug = "setup";   Title = "SETUP";   Icon = "gear";    Accent = $Palette.Cyan;    Accent2 = $Palette.Violet },
  @{ Slug = "donate";  Title = "DONATE";  Icon = "coin";    Accent = $Palette.Magenta; Accent2 = $Palette.Cyan },
  @{ Slug = "regras";  Title = "REGRAS";  Icon = "shield";  Accent = $Palette.Cyan;    Accent2 = $Palette.Magenta },
  @{ Slug = "spotify"; Title = "SPOTIFY"; Icon = "music";   Accent = $Palette.Violet;  Accent2 = $Palette.Cyan },
  @{ Slug = "nft";     Title = "NFT";     Icon = "diamond"; Accent = $Palette.Cyan;    Accent2 = $Palette.Violet }
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

function Draw-NeonText($g, $text, $font, $x, $y, $fill, $accent) {
  $fmt = New-Object System.Drawing.StringFormat
  $fmt.Alignment = [System.Drawing.StringAlignment]::Near
  $fmt.LineAlignment = [System.Drawing.StringAlignment]::Center
  $rect = New-Object System.Drawing.RectangleF($x, $y, 210, 42)
  $glowRect = New-Object System.Drawing.RectangleF(($x + 1), ($y + 1), 210, 42)
  $edgeRect = New-Object System.Drawing.RectangleF(($x + 0.6), ($y + 0.6), 210, 42)
  $shadow = New-Brush $accent 80
  $edge = New-Brush "#000000" 230
  $main = New-Brush $fill 255
  $g.DrawString($text, $font, $shadow, $glowRect, $fmt)
  $g.DrawString($text, $font, $edge, $edgeRect, $fmt)
  $g.DrawString($text, $font, $main, $rect, $fmt)
  $shadow.Dispose()
  $edge.Dispose()
  $main.Dispose()
  $fmt.Dispose()
}

function Draw-Icon($g, $icon, $accent, $accent2, $sx) {
  $penA = New-Pen $accent 3
  $penB = New-Pen $accent2 2
  $brushA = New-Brush $accent 190
  $brushB = New-Brush $accent2 150
  $black = New-Pen "#05070D" 3
  $cx = 39 * $sx
  $cy = 40 * $sx

  switch ($icon) {
    "user" {
      $g.DrawEllipse($penA, 27*$sx, 18*$sx, 24*$sx, 24*$sx)
      $g.DrawArc($penB, 18*$sx, 40*$sx, 42*$sx, 34*$sx, 200, 140)
      $g.DrawLine($penA, 18*$sx, 18*$sx, 13*$sx, 10*$sx)
      $g.DrawLine($penA, 54*$sx, 18*$sx, 60*$sx, 10*$sx)
    }
    "chat" {
      Draw-RoundedRect $g $null $penA (16*$sx) (20*$sx) (48*$sx) (34*$sx) (8*$sx)
      $g.DrawLine($penB, 30*$sx, 54*$sx, 25*$sx, 67*$sx)
      $g.DrawLine($penA, 27*$sx, 34*$sx, 53*$sx, 34*$sx)
      $g.DrawLine($penB, 27*$sx, 43*$sx, 45*$sx, 43*$sx)
    }
    "nodes" {
      $g.DrawEllipse($penA, 17*$sx, 31*$sx, 14*$sx, 14*$sx)
      $g.DrawEllipse($penA, 49*$sx, 18*$sx, 14*$sx, 14*$sx)
      $g.DrawEllipse($penB, 50*$sx, 50*$sx, 14*$sx, 14*$sx)
      $g.DrawLine($penA, 31*$sx, 38*$sx, 49*$sx, 25*$sx)
      $g.DrawLine($penB, 31*$sx, 40*$sx, 50*$sx, 57*$sx)
    }
    "gear" {
      $g.DrawEllipse($penA, 24*$sx, 24*$sx, 30*$sx, 30*$sx)
      $g.DrawEllipse($penB, 34*$sx, 34*$sx, 10*$sx, 10*$sx)
      foreach ($a in 0,45,90,135) {
        $rad = $a * [Math]::PI / 180
        $x1 = $cx + [Math]::Cos($rad) * 21*$sx
        $y1 = $cy + [Math]::Sin($rad) * 21*$sx
        $x2 = $cx + [Math]::Cos($rad) * 30*$sx
        $y2 = $cy + [Math]::Sin($rad) * 30*$sx
        $g.DrawLine($penA, [float]$x1, [float]$y1, [float]$x2, [float]$y2)
      }
    }
    "coin" {
      $g.DrawEllipse($penA, 19*$sx, 21*$sx, 41*$sx, 41*$sx)
      $g.DrawEllipse($penB, 29*$sx, 31*$sx, 21*$sx, 21*$sx)
      $g.DrawLine($penA, 39*$sx, 18*$sx, 39*$sx, 64*$sx)
    }
    "shield" {
      $points = @(
        [System.Drawing.PointF]::new(39*$sx, 14*$sx),
        [System.Drawing.PointF]::new(62*$sx, 24*$sx),
        [System.Drawing.PointF]::new(56*$sx, 56*$sx),
        [System.Drawing.PointF]::new(39*$sx, 68*$sx),
        [System.Drawing.PointF]::new(22*$sx, 56*$sx),
        [System.Drawing.PointF]::new(16*$sx, 24*$sx)
      )
      $g.DrawPolygon($penA, $points)
      $g.DrawLine($penB, 39*$sx, 18*$sx, 39*$sx, 64*$sx)
      $g.DrawLine($penB, 24*$sx, 31*$sx, 54*$sx, 31*$sx)
    }
    "music" {
      $g.DrawLine($penA, 51*$sx, 17*$sx, 51*$sx, 51*$sx)
      $g.DrawLine($penA, 51*$sx, 17*$sx, 30*$sx, 22*$sx)
      $g.DrawLine($penB, 30*$sx, 22*$sx, 30*$sx, 57*$sx)
      $g.DrawEllipse($penA, 17*$sx, 53*$sx, 18*$sx, 12*$sx)
      $g.DrawEllipse($penB, 38*$sx, 47*$sx, 18*$sx, 12*$sx)
    }
    "diamond" {
      $points = @(
        [System.Drawing.PointF]::new(39*$sx, 13*$sx),
        [System.Drawing.PointF]::new(62*$sx, 33*$sx),
        [System.Drawing.PointF]::new(39*$sx, 67*$sx),
        [System.Drawing.PointF]::new(16*$sx, 33*$sx)
      )
      $g.DrawPolygon($penA, $points)
      $g.DrawLine($penB, 16*$sx, 33*$sx, 62*$sx, 33*$sx)
      $g.DrawLine($penB, 39*$sx, 13*$sx, 30*$sx, 33*$sx)
      $g.DrawLine($penB, 39*$sx, 13*$sx, 48*$sx, 33*$sx)
    }
  }

  $penA.Dispose()
  $penB.Dispose()
  $brushA.Dispose()
  $brushB.Dispose()
  $black.Dispose()
}

function Export-PanelPng($panel) {
  $bitmapWidth = $Width * $Scale
  $bitmapHeight = $Height * $Scale
  $bmp = New-Object System.Drawing.Bitmap($bitmapWidth, $bitmapHeight)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  $g.ScaleTransform($Scale, $Scale)

  $bg = New-Brush $Palette.Background
  $panelBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    [System.Drawing.RectangleF]::new(0, 0, $Width, $Height),
    (Convert-HexColor $Palette.Panel),
    (Convert-HexColor $Palette.Panel2),
    0
  )
  $g.FillRectangle($bg, 0, 0, $Width, $Height)
  Draw-RoundedRect $g $panelBrush (New-Pen $panel.Accent 2 210) 10 10 300 60 8

  $g.DrawLine((New-Pen $panel.Accent2 2 170), 14, 17, 72, 17)
  $g.DrawLine((New-Pen $panel.Accent 2 160), 250, 63, 304, 63)
  $g.DrawLine((New-Pen $Palette.Muted 1 130), 87, 20, 87, 60)
  $g.DrawLine((New-Pen $panel.Accent 2 180), 16, 66, 39, 66)
  $g.DrawLine((New-Pen $panel.Accent2 2 150), 286, 14, 304, 32)

  Draw-Icon $g $panel.Icon $panel.Accent $panel.Accent2 1

  $font = New-Object System.Drawing.Font($FontTitle, 24, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  Draw-NeonText $g $panel.Title $font 108 19 $Palette.White $panel.Accent
  $font.Dispose()

  $file = Join-Path $pngDir "$($panel.Slug).png"
  $bmp.Save($file, [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose()
  $bmp.Dispose()
  $bg.Dispose()
  $panelBrush.Dispose()
}

function Export-PanelSvg($panel) {
  $svg = @"
<svg xmlns="http://www.w3.org/2000/svg" width="$Width" height="$Height" viewBox="0 0 $Width $Height" role="img" aria-label="$($panel.Title) Twitch panel">
  <defs>
    <linearGradient id="panel" x1="0" x2="1" y1="0" y2="0">
      <stop offset="0" stop-color="$($Palette.Panel)"/>
      <stop offset="1" stop-color="$($Palette.Panel2)"/>
    </linearGradient>
    <filter id="glow" x="-40%" y="-60%" width="180%" height="220%">
      <feGaussianBlur stdDeviation="2.5" result="blur"/>
      <feMerge>
        <feMergeNode in="blur"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>
  </defs>
  <rect width="$Width" height="$Height" fill="$($Palette.Background)"/>
  <rect x="10" y="10" width="300" height="60" rx="8" fill="url(#panel)" stroke="$($panel.Accent)" stroke-width="2"/>
  <path d="M14 17H72M250 63H304M16 66H39M286 14L304 32" fill="none" stroke="$($panel.Accent2)" stroke-width="2" stroke-linecap="round" filter="url(#glow)"/>
  <path d="M87 20V60" stroke="$($Palette.Muted)" stroke-width="1"/>
  <g transform="translate(0 0)" fill="none" stroke-linecap="round" stroke-linejoin="round" filter="url(#glow)">
    <path d="$((Get-IconPath $panel.Icon))" stroke="$($panel.Accent)" stroke-width="3"/>
  </g>
  <text x="108" y="48" fill="$($Palette.White)" stroke="#05070D" stroke-width="3" paint-order="stroke fill" font-size="31" font-weight="900" font-family="Segoe UI Black, Arial Black, sans-serif" filter="url(#glow)">$($panel.Title)</text>
</svg>
"@
  Set-Content -LiteralPath (Join-Path $svgDir "$($panel.Slug).svg") -Value $svg -Encoding UTF8
}

function Get-IconPath($icon) {
  switch ($icon) {
    "user"    { "M39 18a12 12 0 1 1 0 24a12 12 0 0 1 0-24M18 64c4-14 14-22 21-22s17 8 21 22M18 18l-5-8M54 18l6-8" }
    "chat"    { "M24 20h32a8 8 0 0 1 8 8v18a8 8 0 0 1-8 8H31l-6 13v-13h-1a8 8 0 0 1-8-8V28a8 8 0 0 1 8-8M27 34h26M27 43h18" }
    "nodes"   { "M24 31a7 7 0 1 1 0 14a7 7 0 0 1 0-14M56 18a7 7 0 1 1 0 14a7 7 0 0 1 0-14M57 50a7 7 0 1 1 0 14a7 7 0 0 1 0-14M31 38l18-13M31 40l19 17" }
    "gear"    { "M39 24a15 15 0 1 1 0 30a15 15 0 0 1 0-30M39 34a5 5 0 1 1 0 10a5 5 0 0 1 0-10M39 19v-8M39 69v-8M18 40h-8M68 40h-8M24 25l-6-6M60 61l-6-6M54 25l6-6M18 61l6-6" }
    "coin"    { "M39 21a20.5 20.5 0 1 1 0 41a20.5 20.5 0 0 1 0-41M39 31a10.5 10.5 0 1 1 0 21a10.5 10.5 0 0 1 0-21M39 18v46" }
    "shield"  { "M39 14l23 10l-6 32l-17 12l-17-12l-6-32l23-10M39 18v46M24 31h30" }
    "music"   { "M51 17v34M51 17l-21 5v35M30 57c0 4-4 7-9 7s-9-3-9-7s4-7 9-7s9 3 9 7M51 51c0 4-4 7-9 7s-9-3-9-7s4-7 9-7s9 3 9 7" }
    "diamond" { "M39 13l23 20l-23 34l-23-34l23-20M16 33h46M39 13l-9 20M39 13l9 20" }
  }
}

foreach ($panel in $Panels) {
  Export-PanelPng $panel
  Export-PanelSvg $panel
}

function Export-ContactSheet {
  $cols = 2
  $gap = 18
  $pad = 24
  $labelHeight = 20
  $displayWidth = $Width
  $displayHeight = $Height
  $sheetWidth = ($displayWidth * $cols) + ($gap * ($cols - 1)) + ($pad * 2)
  $rows = [Math]::Ceiling($Panels.Count / $cols)
  $sheetHeight = (($displayHeight + $labelHeight) * $rows) + ($gap * ($rows - 1)) + ($pad * 2)
  $bmp = New-Object System.Drawing.Bitmap($sheetWidth, $sheetHeight)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  $g.Clear((Convert-HexColor $Palette.Background))
  $font = New-Object System.Drawing.Font($FontSmall, 10, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
  $labelBrush = New-Brush "#8C94A7"

  for ($i = 0; $i -lt $Panels.Count; $i++) {
    $panel = $Panels[$i]
    $col = $i % $cols
    $row = [Math]::Floor($i / $cols)
    $x = $pad + ($col * ($displayWidth + $gap))
    $y = $pad + ($row * ($displayHeight + $labelHeight + $gap))
    $img = [System.Drawing.Image]::FromFile((Join-Path $pngDir "$($panel.Slug).png"))
    $g.DrawImage($img, $x, $y, $displayWidth, $displayHeight)
    $g.DrawString("$($panel.Slug).png", $font, $labelBrush, $x, ($y + $displayHeight + 5))
    $img.Dispose()
  }

  $bmp.Save((Join-Path $outDir "preview.png"), [System.Drawing.Imaging.ImageFormat]::Png)
  $font.Dispose()
  $labelBrush.Dispose()
  $g.Dispose()
  $bmp.Dispose()
}

Export-ContactSheet

$previewItems = ($Panels | ForEach-Object {
  "      <figure><img src=""png/$($_.Slug).png"" alt=""$($_.Title)""><figcaption>$($_.Title)</figcaption></figure>"
}) -join "`n"

$preview = @"
<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Twitch panels - mottameister</title>
  <style>
    :root { color-scheme: dark; --bg: #080a10; --fg: #f7fbff; --muted: #8c94a7; --cyan: #39f5ff; --mag: #c13cff; }
    * { box-sizing: border-box; }
    body { margin: 0; min-height: 100vh; background: radial-gradient(circle at 15% 10%, rgba(193,60,255,.16), transparent 28%), radial-gradient(circle at 85% 20%, rgba(57,245,255,.13), transparent 26%), var(--bg); color: var(--fg); font-family: Segoe UI, Arial, sans-serif; }
    main { width: min(1040px, calc(100% - 32px)); margin: 0 auto; padding: 40px 0; }
    h1 { margin: 0 0 8px; font-size: 28px; letter-spacing: 0; }
    p { margin: 0 0 28px; color: var(--muted); }
    .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 18px; align-items: start; }
    figure { margin: 0; padding: 12px; background: rgba(255,255,255,.035); border: 1px solid rgba(255,255,255,.08); border-radius: 8px; }
    img { display: block; width: 320px; max-width: 100%; height: auto; image-rendering: auto; }
    figcaption { margin-top: 8px; color: var(--muted); font-size: 12px; }
    code { color: var(--cyan); }
  </style>
</head>
<body>
  <main>
    <h1>mottameister Twitch panels</h1>
    <p>PNGs em <code>png/</code>, SVGs editáveis em <code>svg/</code>. Tamanho base: 320x80.</p>
    <section class="grid">
$previewItems
    </section>
  </main>
</body>
</html>
"@

Set-Content -LiteralPath (Join-Path $outDir "preview.html") -Value $preview -Encoding UTF8
Write-Host "Generated Twitch panel kit at $outDir"
