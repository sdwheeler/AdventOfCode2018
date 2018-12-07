$claimlist = @()
$fabric = New-Object 'int32[,]' 1000,1000
$fabric.Clear()

'Get claims...'
gc .\input.txt | % {
    $parts = $_ -split ' '
    $claim = New-Object -TypeName psobject -Property @{
        id = $parts[0]
        x = [int32](($parts[2] -split ',')[0])
        y = [int32](($parts[2] -split ',')[1].trim(':'))
        width = [int32](($parts[3] -split 'x')[0])
        height = [int32](($parts[3] -split 'x')[1])
    }
    $claimlist += $claim
}

'Map claims...'
foreach ($claim in $claimlist) {
    #"`t" + $claim.id
    for ($i=0; $i -lt $claim.width; $i++) {
        for ($j=0; $j -lt $claim.height; $j++) {
            $fabric[($i + $claim.x),($j + $claim.y)]++
        }
    }
}

'Count overlap...'
$overlap = 0
for ($i=0; $i -lt 1000; $i++) {
    for ($j=0; $j -lt 1000; $j++) {
        if ($fabric[$i,$j] -gt 1) { $overlap++ }
    }
}
$overlap