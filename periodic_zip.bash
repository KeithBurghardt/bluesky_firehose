

# zip all txt files one at a time  and remove the original
# we specifically compress files that have not been updated in 1+ hours
cd bluesky_data

while :
do
    #find . -maxdepth 1 -type f -name '*.txt' -mmin +59 -exec gzip {} \;
    find . -maxdepth 1 -type f -name 'bluesky_firehose_*.txt' -mmin +59 -exec gzip {} \;
    sleep 3600;
done
