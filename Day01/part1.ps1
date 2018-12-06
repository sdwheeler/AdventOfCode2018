# 489496-20181206-0ec5334c

$a = $c = 0
gc .\input.txt | %{
  $c++
  $m = "$c : Current = $a, Change = $_, Result = "
  $a += $_
  $m += $a
  $m
}
