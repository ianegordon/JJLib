#!/bin/sh

plistFilename="Revision.plist"


isDVCSAvailable=`git --version > /dev/null 2>&1`
if [ 0 -ne $? ]; then
	echo "!!! Unable to find git"
	exit -1
fi


isValidRepository=`git rev-parse HEAD > /dev/null 2>&1`
if [ 0 -ne $? ]; then
	echo "!!! Unable to find git repository"
	exit -1
fi


currentRevision=`git rev-parse HEAD`

fatalString=`echo $currentRevision | cut -c1-6`
if [ "fatal:" = $fatalString ]
then
	echo "Unable to determine Revision: " $currentRevision
	exit -1
else
	:
#	echo "Current Revision: " $currentRevision
fi

isModifiedString=`(git status | grep "modified:\|added:\|deleted:\|renamed:\|new file:" -q) && echo "-M"`

revisionString=$currentRevision$isModifiedString

#echo "Final Revision String : $revisionString"


isPlistBuddyAvailable=`/usr/libexec/PlistBuddy -c "Exit" testtesttest.plist > /dev/null 2>&1`
if [ 0 -ne $? ]; then
    echo "!!! Unable to find PlistBuddy"
    exit -1
fi

if [ ! -e $plistFilename ]
then
	/usr/libexec/PlistBuddy -c "Add :Revision string \"$revisionString\"" $plistFilename
fi

plistRevision=`/usr/libexec/PlistBuddy -c "Print :Revision" $plistFilename`
# echo "Plist Revision:" $plistRevision

if [ "$revisionString" != "$plistRevision" ]
then
	/usr/libexec/PlistBuddy -c "Set :Revision $revisionString" $plistFilename
fi
