# Export chocolatey packages

Write-Output "<?xml version=`"1.0`" encoding=`"utf-8`"?>"
Write-Output "<packages>"
choco list -lo -ry | % { "  <package id=`"$($_.SubString(0, $_.IndexOf("|")))`" />" }
Write-Output "</packages>"
