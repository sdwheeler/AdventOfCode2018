$codes = gc .\input.txt
$counts = @(0) * 255
$two = $three = 0

foreach ($a in $codes) {
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($a)
    $bytes | %{
        $counts[$_]++
    }
    $f2 = $f3 = $false

    foreach ($b in $bytes) {
        if ($counts[$b] -eq 2) {
            $f2 = $true
        }
        elseif ($counts[$b] -eq 3) {
            $f3 = $true
        }
    }
    if ($f2) {$two++}
    if ($f3) {$three++}
    $counts.Clear()
}
"checksum = " + ($two * $three)