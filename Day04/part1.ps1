$log =  gc .\input.txt | sort

$records = @()
$record = [ordered]@{
    name = ''
    day = ''
    sleeptime = 0
    minutes = $null
    map = ''
}

foreach ($line in $log) {
    if ($line -match '\[(?<dt>[0-9:\-\s]{16})\] (?<gd>Guard #[0-9]+) .*') {
        $asleep = $wake = $null
        if ($record.name -ne $Matches.gd) {
            $records += New-Object -type psobject -Property $record
        }
        $record.name = $Matches.gd
        $record.day = ($Matches.dt -split ' ')[0]
        $record.minutes = ('.'*60).ToCharArray()
    }
    elseif ($line -match '\[(?<dt>[0-9:\-\s]{16})\] (?<s>falls asleep)') {
        $asleep = [datetime]$Matches.dt
    }
    elseif ($line -match '\[(?<dt>[0-9:\-\s]{16})\] (?<w>wakes up)') {
        $wake = [datetime]$Matches.dt
    }
    if (($asleep -ne $null) -and ($wake -ne $null)) {
        $record.sleeptime = ($wake - $asleep).minutes
        ($asleep.minute)..($wake.minute-1) | %{ $record.minutes[$_] = '#'}
        $record.map = $record.minutes -join ''
        $asleep = $wake = $null
    }
}

# $records | select name,sleeptime,map | sort name

$groups = $records | group-object name

$sleepy = $groups | %{
     $total = $count = 0
     $_.group | %{
         $name = $_.name
         $count++
         $total +=  $_.sleeptime
     }
     New-Object -TypeName psobject -prop ([ordered]@{ name = $name; total = $total; count=$count })
} | sort total

foreach ($n in $sleepy.name) {
    $time = ,0 * 60
    $records | where name -eq $n | %{
        if ($n -ne '') {
            for ($x=0; $x -lt 60; $x++) {
                if ($_.minutes[$x] -eq '#') {
                    $time[$x]++
                }
            }
        }
    }

    if ($n -ne '') {
        $max = -1
        $sleepminute = -1
        for ($x=0; $x -lt 60; $x++) {
            if ($time[$x] -gt $max) {
                $max = $time[$x]
                $sleepminute = $x
            }
        }
        $g = [int32]($n -split '#')[-1]
        "$n`tminute = $sleepminute`tcount = $max`tAnswer = $($g*$sleepminute)"
    }
}

$records | where {$_.name -eq $sleepy[-1].name}  | select name,day,sleeptime,map
