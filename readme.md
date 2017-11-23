# Vivaldi Profile CLI

##### Documentation still under development, sorry!

Vivali Profile CLI is a command-line utility for managing multiple instance profiles in Vivaldi browser. Think of it like the multiple profile switcher in Chrome.  

Just using the profile name you can open a new instance of Vivaldi using that profile. It will even create the profile for you if it doesn't exist. You can also copy settings from another profile and change which profile is opened as default.

So, now that you have Vivaldi Profile CLI, you can uninstall Chrome! ;)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

OS X, MacOS or Linux with bash
[Vivaldi]('https://vivaldi.com') Web Browser

### Installing

Installing Vivialdi

Install via curl (copy and past this whole block)
```bash
curl https://raw.github.com/wfurphy/vivaldi-profiles-cli/master/vpcli.sh > vpcli.sh && 
  chmod 755 vpcli.sh &&  
  mv vpcli.sh /usr/local/bin/vpcli &&
  source ~/.bashrc
```
OR One step at a time:


1. Download
```bash
curl https://raw.github.com/wfurphy/vivaldi-profiles-cli/master/vpcli.sh
```


2. Add execute (x) permissions 
```bash
chmod 755 vpcli.sh
```


3. Give it a keyboard friendly name like `vpcli` when you move it to /usr/local/bin
```bash
mv vpcli.sh /usr/local/bin/vpcli 
```


4. Make sure you have the updated PATH by sourcing .profile (macOS)
```bash
source ~/.profile
```
 or .bashrc (anywhere respectable).
```bash
source ~/.profile
```

## Versioning

We use [SemVer](http://semver.org/) 

## Authors
Will Furphy - [Technique](https://technique.software)

## License

This project is licensed under the MIT License - see the [LICENSE](wpcli.sh) at the top of the file for details

## Acknowledgments

* Hat tip to Russell Brenner for introducing me to Vivaldi.
