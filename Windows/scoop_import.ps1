# Import exported scoop buckets and apps

gc buckets.txt |% { scoop bucket add $_ }
gc apps.txt |%  {scoop install $_}
