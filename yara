# yara threat detector via file hashes

# osx
 /System/Library/CoreServices/XProtect.bundle/Contents/Resources/

# rule sets
https://github.com/InQuest/awesome-yara#tools

# usage
yara -r -s -m Yara-Rules/malware/* /usr/local/Cellar/hmmer/
