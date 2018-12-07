$log =  gc .\input.txt | sort

$days = @()
$guard = [ordered]@{
    name = ''
    count = 0
    sleeptime = 0
}

foreach ($line in $log) {
    if ($line -match '\[(?<dt>[0-9:\-\s]{16})\] (?<gd>Guard #[0-9]+) .*') {
        if ($guard.name -ne $Matches.gd) {
            $days += new-object -type psobject -prop $guard
        }
        $asleep = $wake = $null
        $guard.name = $Matches.gd
        $guard.count = 0
        $guard.sleeptime = 0
    }
    elseif ($line -match '\[(?<dt>[0-9:\-\s]{16})\] (?<s>falls asleep)') {
        $asleep = [datetime]$Matches.dt
    }
    elseif ($line -match '\[(?<dt>[0-9:\-\s]{16})\] (?<w>wakes up)') {
        $wake = [datetime]$Matches.dt
    }
    if (($asleep -ne $null) -and ($wake -ne $null)) {
        $guard.count++
        $guard.sleeptime += ($wake - $asleep).minutes
        $asleep = $wake = $null
    }
}
$days

# .\part1.ps1 | Group-Object name |sort count | select -last 1 | select -exp group