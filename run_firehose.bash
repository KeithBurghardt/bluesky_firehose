# kill program if file has not been updated in 10 seconds
timeout=10
while :
    do
        # run rrehose.dart
        dart run firehose.dart &
        # firehose program PID
        firehose_pid=$!
        
        # wait for file to be populated
        sleep 10;
        # in case program is hanging:
        # check whether file is being updated
        # if not: kill program (if running) and restart
        while : ; do
            # wait a little bit to avoid needless file-checking
            sleep 1
            # find the newest file being saved
            newest_file=$(ls -Art bluesky_firehose_* | tail -n 1)
            # find the time the newest file was being made
            file_update_time=$(date -r $newest_file +%s) 
            # convert to seconds integer
            file_update_time_seconds=$(echo $file_update_time ) # | awk -F '{print($1)}')
            # current time, seconds integer
            current_time_seconds=$(echo $(date +%s) | awk -F: '{ print ($1)}')
            # how long file has not been updated in seconds
            diff=$(($current_time_seconds-$file_update_time))
            # kill if timeout
            if [[ $diff -gt $timeout ]]; then                
                # kill PID if it exists (not needed in most/all cases, but it avoids a zombie program)
                if ps -p $PID > /dev/null
                then
                    kill $firehose_pid
                fi
                break
            fi
        done
    done
