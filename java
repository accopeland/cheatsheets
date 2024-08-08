---
tags: [ java, jar ]
---

# update java
brew cask uninstall java
brew cask install java --verbose
java --version
jenv add /Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/
jenv versions

# java version mismatch
Java SE 12 = 56 (0x38 hex)
Java SE 11 = 55 (0x37 hex)
Java SE 10 = 54
Java SE 9 = 53
Java SE 8 = 52
Java SE 7 = 51
Java SE 6.0 = 50
Java SE 5.0 = 49
JDK 1.4 = 48
JDK 1.3 = 47
JDK 1.2 = 46
JDK 1.1 = 45

# all of the stupid versions install dirs
/Library/Java/JavaVirtualMachines/1.6.0.jdk
/Library/Java/JavaVirtualMachines/jdk1.7.0_55.jdk
/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk
/Library/Java/JavaVirtualMachines/openjdk-14.0.2.jdk
/Library/Java/JavaVirtualMachines/adoptopenjdk-16.jdk

# packaging
https://github.com/Jorl17/jar2app -- defunct
https://github.com/libgdx/packr
AppBundler - https://alvinalexander.com/java/how-build-macos-application-from-java-jar-file-jarbundler/

# packr
java -jar packr-all.jar \
     --platform mac \
     --jdk OpenJDK11U-jre_x64_mac_hotspot_11.0.10_9.tar.gz \
     --useZgcIfSupportedOs \
     --executable myapp \
     --classpath myjar.jar \
     --mainclass com.my.app.MainClass \
     --vmargs Xmx1G \
     --resources src/main/resources path/to/other/assets \
     --output out-mac

# macos old java :  https://support.apple.com/kb/DL1572?locale=en_US

# brew versions:
brew tap homebrew/cask-versions
brew cask install java6 # need for passwordsafeSWT
jenv add /Library/Java/JavaVirtualMachines/openjdk-14.0.2.jdk/Contents/Home/
jenv global 1.6

# java / jenv
brew install jenv

# add bash_profile stuff
 jenv add /Library/Java/JavaVirtualMachines/jdk1.8.0_66.jdk/Contents/Home
oracle64-1.8.0.66 added
1.8.0.66 added
1.8 added

#  /usr/libexec/java_home -V

# PasswordSafeSWT - /Applications/PasswordSafeSWT.app/Contents/MacOS/JavaApplicationStub
brew cask install java6
jenv global 1.6 # jenv add
/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home/bin/javac -version
javac 1.6.0_65
/Applications/PasswordSafeSWT.app/Contents/MacOS/JavaApplicationStub - works with 1.8 ; NOT with 9-ea

# To execute a java program
# To run a java file
java -jar <filename.jar>

# To pass arguments to your java program
java -jar <filename.jar> <arg1> <arg2> ...
java -jar example.jar "Hello world" 1234

# To get the version of the installed java enviroment
java -showversion

Example output:
openjdk version "11.0.8" 2020-07-14
OpenJDK Runtime Environment (build 11.0.8+10-post-Ubuntu-0ubuntu120.04)
OpenJDK 64-Bit Server VM (build 11.0.8+10-post-Ubuntu-0ubuntu120.04, mixed mode, sharing)

# To set the intial memory size to be used by the program
# Use -Xms<size> to set inital memory allocation
# Use -Xmx<size> to set maximun allowed memory allocation
# Use -Xss<size> to set maximun allowed thread stack size
# Initially asigns 256mb and allows up to 2gb, thread stack size of 1mb
java -Xms256m -Xmx2g -Xss1m -jar <filename.jar>

# To use the classpath variable
# It overrides the CLASSPATH of Environment variable but only for that session.
# If you restart the application you need to again set the classpath variable.
# You can use either: -classpath, --classpath or -cp
java -classpath <classpath> -jar <filename.jar>
java -classpath "my/example/path/one:my/example/path/two" -jar myfile.zip

# To execute a java class
# Say you have a java class of name HelloWorld in a file called HelloWorld.java
# Say you want to execute your class HelloWorld and pass it the argument "hello"
# Say the file is the local directory we use the options "-cp ."
java -cp <path> <class> <arg>
java -cp . HelloWorld "hello"
