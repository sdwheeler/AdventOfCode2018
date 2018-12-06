# 489496-20181206-0ec5334c

$a = $c = $x = 0
$set = @{0=0}
$found = $false
while (!$found) {
  $x++
  "Iteration $x"
  gc .\input.txt | %{
    $c++
    $a += $_
    $ErrorActionPreference = "Stop"
    try {
      $set.Add($a,$c)
    }
    catch {
      "Duplicate $a"
      $ErrorActionPreference = "Continue"
      $found = $true
      break
    }
  }
}

