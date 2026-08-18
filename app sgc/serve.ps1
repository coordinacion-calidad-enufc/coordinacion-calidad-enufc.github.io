$port = 5500
$dir  = Split-Path -Parent $MyInvocation.MyCommand.Path

$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Host "SGC server running at http://localhost:$port/"

while ($listener.IsListening) {
    $ctx  = $listener.GetContext()
    $req  = $ctx.Request
    $res  = $ctx.Response
    $path = $req.Url.LocalPath -replace '^/',''
    if ($path -eq '') { $path = 'index.html' }
    $file = Join-Path $dir $path

    if (Test-Path $file -PathType Leaf) {
        $ext  = [IO.Path]::GetExtension($file).ToLower()
        $mime = switch ($ext) {
            '.html' { 'text/html; charset=utf-8' }
            '.js'   { 'application/javascript' }
            '.css'  { 'text/css' }
            '.png'  { 'image/png' }
            '.jpg'  { 'image/jpeg' }
            '.jpeg' { 'image/jpeg' }
            '.svg'  { 'image/svg+xml' }
            '.json' { 'application/json' }
            '.ico'  { 'image/x-icon' }
            '.webp' { 'image/webp' }
            default { 'application/octet-stream' }
        }
        $bytes = [IO.File]::ReadAllBytes($file)
        $res.ContentType     = $mime
        $res.ContentLength64 = $bytes.Length
        $res.OutputStream.Write($bytes, 0, $bytes.Length)
        $res.StatusCode = 200
    } else {
        # SPA fallback — serve index.html for unknown paths
        $index = Join-Path $dir 'index.html'
        $bytes = [IO.File]::ReadAllBytes($index)
        $res.ContentType     = 'text/html; charset=utf-8'
        $res.ContentLength64 = $bytes.Length
        $res.OutputStream.Write($bytes, 0, $bytes.Length)
        $res.StatusCode = 200
    }
    $res.Close()
}
