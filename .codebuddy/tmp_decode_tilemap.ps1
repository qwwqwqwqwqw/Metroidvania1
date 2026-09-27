# Decode Godot 4 TileMapLayer tile_map_data (PackedByteArray) from a .tscn and report cells near a point
$projectRoot = Split-Path -Parent $PSScriptRoot
$ScenePath = Join-Path $projectRoot "levels\00_forest\01.tscn"
[int]$SpawnX = 148
[int]$SpawnY = 206
[int]$TileSize = 32

$out = New-Object System.Collections.Generic.List[string]
$lines = Get-Content -Path $ScenePath
$nodeName = ""
$idx = 0
foreach ($line in $lines) {
    $idx++
    if ($line -match '^\[node name="([^"]+)" type="TileMapLayer" parent="([^"]*)"') {
        $nodeName = ($Matches[2] + "/" + $Matches[1]) -replace "^/", ""
    }
    if ($line -match 'tile_map_data = PackedByteArray\("([A-Za-z0-9+/=]+)"\)') {
        $b64 = $Matches[1]
        $bytes = [Convert]::FromBase64String($b64)
        $out.Add("=== Layer: $nodeName (line $idx, $($bytes.Length) bytes) ===")
        $i = 2 # skip 2-byte version header
        $cells = @()
        while ($i + 12 -le $bytes.Length) {
            $x = [BitConverter]::ToInt16($bytes, $i)
            $y = [BitConverter]::ToInt16($bytes, $i + 2)
            $src = [BitConverter]::ToUInt16($bytes, $i + 4)
            $ax = [BitConverter]::ToInt16($bytes, $i + 6)
            $ay = [BitConverter]::ToInt16($bytes, $i + 8)
            $alt = [BitConverter]::ToUInt16($bytes, $i + 10)
            $cells += [PSCustomObject]@{ x = $x; y = $y; src = $src; ax = $ax; ay = $ay; alt = $alt }
            $i += 12
        }
        $out.Add("total cells: " + $cells.Count)
        $xr = $cells | Measure-Object x -Minimum -Maximum
        $yr = $cells | Measure-Object y -Minimum -Maximum
        $out.Add("x range: $($xr.Minimum)..$($xr.Maximum) ; y range: $($yr.Minimum)..$($yr.Maximum)")

        $tx = [math]::Floor($SpawnX / $TileSize)
        $ty = [math]::Floor($SpawnY / $TileSize)
        $out.Add("spawn tile: ($tx, $ty); cells x in [$($tx-4)..$($tx+6)], y in [$($ty-6)..$($ty+8)]:")
        $near = $cells | Where-Object { $_.x -ge ($tx - 4) -and $_.x -le ($tx + 6) -and $_.y -ge ($ty - 6) -and $_.y -le ($ty + 8) } | Sort-Object y, x
        foreach ($c in $near) {
            $px = $c.x * $TileSize; $py = $c.y * $TileSize
            $out.Add(("  tile({0,3},{1,3}) src={2} atlas=({3},{4}) alt={5}  -> pixel rect x[{6},{7}] y[{8},{9}]" -f $c.x, $c.y, $c.src, $c.ax, $c.ay, $c.alt, $px, ($px + $TileSize), $py, ($py + $TileSize)))
        }
        $out.Add("")
    }
}
$out | Out-File -FilePath (Join-Path $PSScriptRoot "tmp_tilemap_result.txt") -Encoding UTF8
Write-Output "DONE, lines: $($out.Count)"
