#!/bin/sh

plistFilename="Revision.plist"


isDVCSAvailable=`svn --version > /dev/null 2>&1`
if [ 0 -ne $? ]; then
	echo "!!! Unable to find svn"
	exit -1
fi


isValidRepository=`svn info > /dev/null 2>&1`
if [ 0 -ne $? ]; then
	echo "!!! Unable to find subversion repository"
	exit -1
fi


currentRevision=`svnversion -n`
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

plistRevision=`/usr/libexec/PlistBuddy -c "Print :Revision" $plistFilename)`
# echo "Plist Revision:" $plistRevision

if [ "$currentRevision" != "$plistRevision" ]
then
	/usr/libexec/PlistBuddy -c "Set :Revision $currentRevision" $plistFilename
fi
