# 写真保管庫.html のバックアップを作成する
# ※ 日本語の文字列はコード番号から組み立てている。
#    このファイルの文字コードが何であっても、フォルダ名が化けないようにするため。

$backupDirName = [string]::Join('', [char[]](0x30D0,0x30C3,0x30AF,0x30A2,0x30C3,0x30D7))  # バックアップ

# スクリプトと同じフォルダにある .html のうち、一番新しいものを対象にする
$src = Get-ChildItem -LiteralPath $PSScriptRoot -Filter *.html -File |
       Sort-Object LastWriteTime -Descending |
       Select-Object -First 1

if ($null -eq $src) {
    Write-Host "[ERROR] No .html file found in this folder." -ForegroundColor Red
    exit 1
}

$dir = Join-Path $PSScriptRoot $backupDirName
if (-not (Test-Path -LiteralPath $dir)) {
    New-Item -ItemType Directory -Path $dir | Out-Null
}

$stamp = Get-Date -Format 'yyyyMMdd-HHmm'
$dst   = Join-Path $dir ($src.BaseName + '_' + $stamp + $src.Extension)

# 同じ分に2回実行したときに上書きしないよう、連番を付ける
$n = 1
while (Test-Path -LiteralPath $dst) {
    $dst = Join-Path $dir ($src.BaseName + '_' + $stamp + '_' + $n + $src.Extension)
    $n++
}

Copy-Item -LiteralPath $src.FullName -Destination $dst -Force

Write-Host ""
Write-Host "  OK - backup created" -ForegroundColor Green
Write-Host ""
Write-Host ("  FROM : " + $src.Name + "  (" + [math]::Round($src.Length/1KB) + " KB)")
Write-Host ("  TO   : " + (Split-Path $dst -Leaf))
Write-Host ""

# 保管している世代数を表示
$all = Get-ChildItem -LiteralPath $dir -Filter *.html -File
Write-Host ("  " + $all.Count + " backups stored in this folder.")
Write-Host ""
