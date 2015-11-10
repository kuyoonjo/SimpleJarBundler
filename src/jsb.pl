use strict;
use warnings;
use File::Spec;

my ($output,
$libDir,
$CFBundleName,
$CFBundleShortVersionString,
$CFBundleIconFile,
$JarFile,
$MainClass,
$resource) = @ARGV;

my $dir = "$output/Contents";
system "mkdir -p $dir/MacOS";
system "mkdir -p $dir/Resources/Java";

system "cp $libDir/bin/JavaApplicationStub $dir/MacOS/" if -e "$libDir/bin/JavaApplicationStub";
system "cp $CFBundleIconFile $dir/Resources/" if -e $CFBundleIconFile;
system "cp $JarFile $dir/Resources/Java/" if -e $JarFile;
if(defined $resource and -d $resource) {
    system "cp -r $resource/. $dir/Resources/Java";
}

my @array = split /\//, $JarFile;
my $JarFileName = pop @array;

open(my $fh, '>', "$dir/Info.plist");

print $fh <<EOF;
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>CFBundleName</key>
<string>$CFBundleName</string>
<key>CFBundleShortVersionString</key>
<string>$CFBundleShortVersionString</string>
<key>CFBundleAllowMixedLocalizations</key>
<string>false</string>
<key>CFBundleInfoDictionaryVersion</key>
<string>6.0</string>
<key>CFBundleExecutable</key>
<string>JavaApplicationStub</string>
<key>CFBundleDevelopmentRegion</key>
<string>English</string>
<key>CFBundleIconFile</key>
<string>$CFBundleIconFile</string>
<key>Java</key>
<dict>
<key>MainClass</key>
<string>$MainClass</string>
<key>JVMVersion</key>
<string>1.3+</string>
<key>ClassPath</key>
<array>
<string>\$JAVAROOT/$JarFileName</string>
</array>
<key>Properties</key>
<dict>
<key>com.apple.mrj.application.apple.menu.about.name</key>
<string>$CFBundleName</string>
</dict>
</dict>
</dict>
</plist>
EOF

close($fh);