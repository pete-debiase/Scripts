# Export scoop buckets and apps

# Buckets
scoop export | select-string '\) \[(.+)\]$' |% {
    $_.matches.groups[1].value } | select -unique > "C:\~\.sel\package_lists\scoop_buckets.txt"

# Apps
scoop export | select-string '^(.+)\W\(v:' |% {
    $_.matches.groups[1].value } > "C:\~\.sel\package_lists\scoop_apps.txt"
