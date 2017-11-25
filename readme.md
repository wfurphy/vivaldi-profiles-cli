# Vivaldi Profiles CLI

Vivaldi Profile CLI is a command-line utility for managing multiple instance profiles in [Vivaldi]('https://vivaldi.com') browser. Think of it as a cli version of the multiple profile switcher in Chrome.

Specify a profile name `vpcli profilename` and an instance of Vivaldi opens using that profile. A new profile of that name will be created if one doesn't exist. You can also list all of your profiles, copy settings from a profile to new or existing profile and change which profile is opened by default.

Backup your profiles and make them portable between devices by keeping them on Dropbox or another cloud storage platform. (Although, I tested this on MacOS and due to the profile containing cache and other frequently accessed files there certainly is a performance consideration to be made here. It isn't set as the default option until I find a better way to do it). 

So, now that you have Vivaldi Profiles CLI, you can uninstall Chrome! ;)

## Getting Started
These instructions will get you a copy of VPCLI up and running on your local machine.

### Prerequisites
* OS X, MacOS or Linux with bash
* [Vivaldi](https://vivaldi.com) web browser

#### WARNING: This is beta software. Please backup your profile before you start!
Please remember, this has only had limited testing. You need to make a backup of your current default profile if you don't want to loose all of your settings! 
Quit Vivaldi and then backup your profile! The examples below create a tar archive (assuming you have Vivaldi installed with default locations).

MacOS
```bash
tar -zcvf ~/Documents/vivaldi-profile.tgz ~/Library/"Application Support"/Vivaldi
```
Linux
```bash
tar -zcvf ~/vivaldi-profile.tgz ~/.config/vivaldi
```

### Installation

[Download](https://www.google.com.au/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwjKtf6m89XXAhUIkZQKHYCuBVYQFggmMAA&url=https%3A%2F%2Fvivaldi.com%2Fdownload%2F%3Flang%3Den&usg=AOvVaw1b7SMyM9QJfW0t_REb_z9R) and Install Vivialdi if you don't have it yet.

#### Copy and paste this entire block in terminal
```bash
curl -O https://raw.githubusercontent.com/wfurphy/vivaldi-profiles-cli/master/vpcli.sh && 
  chmod 755 vpcli.sh &&  
  mv vpcli.sh /usr/local/bin/vpcli &&
  vpcli
  
```

#### OR One step at a time
1. Download
```bash
curl -O https://raw.githubusercontent.com/wfurphy/vivaldi-profiles-cli/master/vpcli.sh
```
2. Add execute (x) permissions 
```bash
chmod 755 vpcli.sh
```
3. Give it a keyboard friendly name like `vpcli` when you move it to /usr/local/bin
```bash
mv vpcli.sh /usr/local/bin/vpcli
```
4. Test
```bash
vpcli
```

**You should see the help or RTFM screen seen below under Useage*

If you have any issues then please make sure you have followed the previous steps correctly. If you have `vpcli` in your `/usr/local/bin` directory and are still not able to access the command then please ensure you are loading the updated PATH by sourcing your bash profile settings.
.profile (macOS)
```bash
source ~/.profile
```
 or .bashrc (everywhere else).
```bash
source ~/.bashrc
```

## Configuration
If you're using MacOS then you probably won't need to change anuthing. You can change the default settings by editing the Configuration section in `vpcli.sh` or `usr/local/bin/vpcli` once it's installed. For example:
```bash
vim /usr/local/bin/vpcli
```
_*I use vim but you can replace this with whichever editor you prefer._

##### Default Profile Location (vpcli_path)
The path where Vivaldi Profiles CLI will store and manage your profiles.
This is set to the MacOS version `"${HOME}/Library/Application Support/Vivaldi-Profiles"` as default.

##### Default Profile Location (vpcli_default)
The path to your existing Vivaldi Location.
This is set to the MacOS version `"${HOME}/Library/Application Support/Vivaldi"` as default.

## Useage

![vpcli-manual](img/vpcli.png)

## Versioning
We use [SemVer](http://semver.org/) 

## Authors
Will Furphy - [Technique](https://technique.software)

## License
This project is licensed under the MIT License - see the [LICENSE](wpcli.sh) at the top of the file for details

## Acknowledgments
* Hat tip to Russell Brenner for introducing me to Vivaldi and for finding my pesky typo!

## TODO
There are lots of features that can be added, of course. I've listed some of the ones I will be working on in the TODO comments in [vpcli.sh](vpcli.sh). I'll try to keep them upated here too (they are not in any particular order). Always happy to consider contributions and suggestions.

**TODO**
* Finish `-b` Backup feature
* Improve changing default profile process
* Add `-v` Verbose mode
* Add `-s` Silent mode (Success is silent anyway, as it should be for *nix commands. Silent will provide complete blackout for use with other scripts / apps)
* Add `-q` Quit Options
* Add `-p` `--prefs` (?) Change default settings via CLI (auto on first run)
* Dropbox: Asses viability of restricting to profile files and not have entire prefs and cache for instance in Dropbox
