$html = Get-Content 'index.html' -Raw -Encoding UTF8

$tags = @('html', 'head', 'body', 'header', 'main', 'footer', 'script', 'style', 'section', 'nav', 'div')
foreach ($t in $tags) {
    $openCount = ([regex]::Matches($html, "<$t(\s|>)")).Count
    $closeCount = ([regex]::Matches($html, "</$t>")).Count
    Write-Host "$t : open=$openCount close=$closeCount"
}

$styleMatch = [regex]::Match($html, '(?s)<style>(.*?)</style>')
if ($styleMatch.Success) {
    $sc = $styleMatch.Groups[1].Value
    $ob = ($sc.ToCharArray() | Where-Object { $_ -eq '{' }).Count
    $cb = ($sc.ToCharArray() | Where-Object { $_ -eq '}' }).Count
    Write-Host "Style braces: open=$ob close=$cb"
}

$scriptMatch = [regex]::Match($html, '(?s)<script>(.*?)</script>')
if ($scriptMatch.Success) {
    $sc = $scriptMatch.Groups[1].Value
    $ob = ($sc.ToCharArray() | Where-Object { $_ -eq '{' }).Count
    $cb = ($sc.ToCharArray() | Where-Object { $_ -eq '}' }).Count
    $op = ($sc.ToCharArray() | Where-Object { $_ -eq '(' }).Count
    $cp = ($sc.ToCharArray() | Where-Object { $_ -eq ')' }).Count
    Write-Host "Script braces: open=$ob close=$cb | parens: open=$op close=$cp"
}

$jpMatches = [regex]::Matches($html, '[\u3040-\u30ff\u4e00-\u9faf]')
Write-Host "Japanese characters: $($jpMatches.Count)"
