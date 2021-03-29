#!/bin/bash

echo "@@@@@ Stats from our personal file:"
cat temp.dat | grep 'Accepted' | wc -l | awk '
	{
		A = $1/(60*18 + 35)
		printf "\tAccepted:\n"
		printf "\t\tTotal Shares      : %d\n", $1
		printf "\t\tShares per Minute : %.3f\n", A
		printf "\t\tShares per Hour   : %.3f\n", 60*A
	}'

cat temp.dat| grep 'incorrect result' | wc -l | awk '
	{
		A = $1/(60*18 + 35)
		printf "\tRejected/Stale:\n"
		printf "\t\tTotal Shares      : %d\n", $1
		printf "\t\tShares per Minute : %.3f\n", A
		printf "\t\tShares per Hour   : %.3f\n", 60*A
	}'

echo;echo;

cat temp.dat| grep ' Mh ' | awk '{print $4, $8, $10}' | sed 's/,//g' | awk '
	BEGIN {
		combined = 0;
		device1 = 0;
		device2 = 0;
	} 
	{
		combined += $1
		device1 += $2
		device2 += $3
	}
	END {
		avgCombined = combined / NR;
		avgDevice1 = device1 / NR;
		avgDevice2 = device2 / NR;

		printf "\tNumber of hash attempts %d\n", NR
		printf "\tCombined              : %.3f\n", avgCombined
		printf "\tDevice1 (likely 4000) : %.3f\n", avgDevice1
		printf "\tDevice2 (likely 3070) : %.3f\n", avgDevice2
	}'




echo;echo;echo;
echo "@@@@@ Stats from ethermine:"
curl -s https://api.ethermine.org/miner/634486DB5b417Bab9D6eE89d6821D6434F354c21/dashboard | jq -s '.[0].data.statistics[] | [.validShares, .invalidShares, .staleShares] | @csv' | sed 's/"//g;s/,/ /g' | awk '
	BEGIN {
		valid = 0;
		invalid = 0;
		stale = 0;
	} 
	{
		valid += $1
		invalid += $2
		stale += $3
	}
	END {
		avgValid = valid / NR;
		avgInvalid = invalid / NR;
		avgStale = stale / NR;

		printf "\tNumber of reports to ethermine %d (over %d hours)\n", NR, NR/6
		printf "\tValid  : \n\t\tAverage: %.3f\n\t\tPerMinute: %.3f\n", avgValid, avgValid/60
		printf "\tInvalid: \n\t\tAverage: %.3f\n\t\tPerMinute: %.3f\n", avgInvalid, avgInvalid/60
		printf "\tStale  : \n\t\tAverage: %.3f\n\t\tPerMinute: %.3f\n", avgStale, avgStale/60
	}
'
