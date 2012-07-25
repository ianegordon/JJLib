#!/bin/sh

plistFilename="Revision.plist"

isDVCSAvailable=`hg > /dev/null 2>&1`
if [ 0 -ne $? ]; then
	echo "!!! Unable to find hg"
fi


#TODO Determine if we have a valid hg repo
#Example from git script:
#isValidRepository=`git rev-parse HEAD > /dev/null 2>&1`
#if [ 0 -ne $? ]; then
#	echo "!!! Unable to find git repository"
#fi


currentRevision=$(hg sum | grep parent | awk '{ print $2 }')

if [ "exported" = $currentRevision ]
then
	currentRevision=""
#	echo "Current Revision: " $currentRevision
else
	:
#	echo "Current Revision: " $currentRevision
fi


isPlistBuddyAvailable=`/usr/libexec/PlistBuddy -c "Exit" testtesttest.plist > /dev/null 2>&1`
if [ 0 -ne $? ]; then
    echo "!!! Unable to find PlistBuddy"
    exit -1
fi

if [ ! -e $plistFilename ]
then
	/usr/libexec/PlistBuddy -c "Add :Revision string \"$currentRevision\"" $plistFilename
fi

plistRevision=$(/usr/libexec/PlistBuddy -c "Print :Revision" $plistFilename)
# echo "Plist Revision:" $plistRevision

if [ "$currentRevision" != "$plistRevision" ]
then
	/usr/libexec/PlistBuddy -c "Set :Revision $currentRevision" $plistFilename
fi
