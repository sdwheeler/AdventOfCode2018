$claimlist = @()
$fabric = New-Object 'string[,]' 1000,1000
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
    for ($i=0; $i -lt $claim.width; $i++) {
        for ($j=0; $j -lt $claim.height; $j++) {
            if ($fabric[($i + $claim.x),($j + $claim.y)] -eq $null) {
                $fabric[($i + $claim.x),($j + $claim.y)] = $claim.id
            } else {
                $fabric[($i + $claim.x),($j + $claim.y)] = 'XXX'
            }
        }
    }
}

'Search for non-overlap'
foreach ($claim in $claimlist) {
    $found = $true
    #"`tTesting " + $claim.id
    for ($i=0; $i -lt $claim.width; $i++) {
        for ($j=0; $j -lt $claim.height; $j++) {
            if ($fabric[($i + $claim.x),($j + $claim.y)] -ne $claim.id) {
                $found = $false
                break
            }
        }
    }
    if ($found) {
        "Found " + $claim.id
        break
    }
}

#$fabric