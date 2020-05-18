#!/usr/bin/bash -f
export PATH="/usr/local/bin:/usr/bin:/bin"
H=$(date +%H)

##TimeOn - When you want Concentration to Begin - single digit if less than 10; do not write "08", write 8.
TimeOn=8
##TimeOff - When you want Concentration to Finish - Single digit if less than 10; do not write "08", write 8.
TimeOff=18

if (( TimeOn <= 10#$H && 10#$H < TimeOff )); then 
    echo "It's time for some concentration!"
    if [ -f /tmp/concentration_state_active ]; then
        echo "Concentration is already improved. Sites should already be blocked?"
    else 
        concentration improve && touch /tmp/concentration_state_active && echo "Concentration improved. Sites on blocklist are blocked. Activating."
    fi;
else 
    echo "It's no longer time for concentration."
    if [ -f /tmp/concentration_state_active ]; then
        echo "It's no longer time for concentration. Deactivating and making sites on blocklist available."
        rm /tmp/concentration_state_active
        concentration lose
    else 
        echo "Concentration is deactivated. Sites on blocklist should be available."
    fi;
fi;