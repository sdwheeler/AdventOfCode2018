$codes = gc .\input.txt
for ($x=0; $x -lt $codes.count; $x++) {
    for ($y=0; $y -lt $codes.count; $y++) {
        $result = 0
        $common = ""
        $a = $codes[$x].ToCharArray()
        $b = $codes[$y].ToCharArray()
        for ($i=0; $i -lt $a.Count; $i++) {
            if ($a[$i] -ne $b[$i]) {
                $result++
                $diffs = "Diffs = {0}, {1}" -f $a[$i], $b[$i]
            } else {
                $common += $a[$i]
            }
        }
        if ($result -eq 1) {
            $codes[$x]
            $codes[$y]
            "Common letters = " + $common
            $diffs
            break
        }
    }
}
