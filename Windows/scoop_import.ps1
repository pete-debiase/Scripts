# Import exported scoop buckets and apps

gc "C:\~\.sel\package_lists\scoop_buckets.txt" |% { scoop bucket add $_ }
gc "C:\~\.sel\package_lists\scoop_apps.txt" |%  { scoop install $_ }
