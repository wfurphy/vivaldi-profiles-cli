#!/usr/bin/env bash

#|---------------------------------------------------------------------------------------------------->
#| Vivaldi Profiles CLI v0.1.4
#|
#| A command-line utility for managing multiple instance profiles in Vivaldi browser.
#| Author: Will Furphy
#| GitHub: https://github.com/wfurphy/vivaldi-profiles-cli
#| Vivaldi: https://vivaldi.com
#|---------------------------------------------------------------------------------------------------->
#| MIT License
#|
#| Copyright (c) 2017 Will Furphy
#|
#| Permission is hereby granted, free of charge, to any person obtaining a copy
#| of this software and associated documentation files (the "Software"), to deal
#| in the Software without restriction, including without limitation the rights
#| to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#| copies of the Software, and to permit persons to whom the Software is
#| furnished to do so, subject to the following conditions:
#|
#| The above copyright notice and this permission notice shall be included in all
#| copies or substantial portions of the Software.
#|
#| THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#| IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#| FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#| AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#| LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#| OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#| SOFTWARE.

#|---------------------------------------------------------------------------------------------------->
#| Configuration
#|---------------------------------------------------------------------------------------------------->

#|---------------------------------------------------------------->
#| Profile Path
#| Where you would like this tool to store your profiles
#|---------------------------------------------------------------->
# Uncomment one or write in your own fully qualified custom path
# Dropbox on MacOS ( WARNING: Potential performance issues. )
#vpcliPath="${HOME}/Dropbox/Vivaldi-Profiles"
# MacOS
vpcli_path="${HOME}/Library/Application Support/Vivaldi-Profiles"
# Linux
#vpcliPath="${HOME}/.config/vivaldi-profiles"

#|---------------------------------------------------------------->
#| Default Vivaldi Profile
#| Where Vivaldi loads your default profile from (the only one it has)
#|---------------------------------------------------------------->
# Uncomment one or write in your own fully qualified custom path
# MacOS
vpcli_default="${HOME}/Library/Application Support/Vivaldi"
# Linux
#VCLI_CSOURCE="${HOME}/.config/vivaldi"

#| End Configuration
#|---------------------------------------------------------------------------------------------------->


#| THINGS TODO ::>
#|---------------------------------------------------------------->
# TODO> Finish -b? Backup feature
# TODO> Improve changing default profile process
# TODO> Add -v Verbose mode
# TODO> Add -s Silent mode (Success is silent anyway, as it should be for *nix commands. Silent will provide complete blackout for use with other scripts / apps)
# TODO> Add -q Quit Options
# TODO> Add -p? --prefs? Alter default settings via CLI
# TODO> Dropbox: Asses viability of restricting to profile files and not have entire prefs and cache for instance in Dropbox

if [ $# -eq 0 ]; then
    echo $''
    echo $'\e[1;36m::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::> \e[0m'
    echo $'\e[1;36m:: Vivaldi Profiles CLI :: \e[0m\e[1mUseage and Options (RTFM) \e[1;36m:::>\e[0m                                           \e[1;36mv0.1.4 \e[0m'
    echo $'\e[1;36m::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::> \e[0m'
    echo $''
    echo $''
    echo $'\e[1;36mDescription :::>'
    echo $''
    echo $'             \e[0mA command-line utility for managing multiple instance profiles in Vivaldi browser.'
    echo $'             \e[0mOpens a new instance of Vivaldi using the target profile. If the target does not'
    echo $'             \e[0mexist a new profile will be created and opened in Vivaldi.'
    echo $''
    echo $'             \e[1mhttps://github.com/wfurphy/vivaldi-profiles-cli  \e[0m|  \e[0m\e[1mhttps://vivaldi.com\e[0m'
    echo $''
    echo $''
    echo $'\e[1;36mSynopsis :::>'
    echo $''
    echo $'             \e[0m\e[1mvpcli \e[0m\e[4mprofile\e[0m'
    echo $'             \e[0m\e[1mvpcli \e[0m[ \e[1m-l\e[0m ] \e[0m[ \e[0m[ \e[1m-n\e[0m ] [ \e[1m-d \e[0m] [ \e[1m-c\e[0m \e[4msource\e[0m ] \e[4mprofile\e[0m \e[0m]'
    echo $''
    echo $'   \e[0m\e[4mprofile\e[0m   The name of your profile. (required, case sensitive)'
    echo $'             \e[0mA new profile will be created if the requested one does not exist.'
    echo $''
    echo $''
    echo $'\e[1;36mOptions :::>'
    echo $''
    echo $'   \e[0m\e[1m-l        List: \e[0mShows a list of all of your existing profiles.'
    echo $''
    echo $'   \e[0m\e[1m-n        No New Mode: \e[0mChanges the default behaviour. The target profile will NOT'
    echo $'             \e[0mbe created if it does not exist and an error will be thrown.'
    echo $''
    echo $'   \e[0m\e[1m-d        Set Default: \e[0mMake the specified profile your default profile.'
    echo $'             \e[0mWARNING: This will overwrite the current default (confirmation required).'
    echo $''
    echo $'   \e[0m\e[1m-c \e[0m\e[4msource\e[0m'
    echo $'             \e[1mCopy Profile: \e[0mMakes a complete copy of the source profile under the target profile.'
    echo $'             \e[0mConfirmation is required to overwrite existing profiles. Providing \e[4mdefault\e[0m as'
    echo $'             \e[0mthe source will copy from the default Vivaldi location.'
    echo $''
    echo $'\e[1;36m::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::> \e[0m'
    echo $''
    exit
fi

function errorExit {
    echo $'\e[91mERROR::> ' "$1" $'\e[0m' 1>&2
    exit 1
}

function sendWarning {
    echo $'\e[93mWARNING::> ' "$1" $'\e[0m' 1>&2
}

function isDefault {
    [ "${1}" == "${vpcli_config_default}" ] && echo "1"
}

function listProfiles {
    local default_text=""
    local profile_text=""
    echo $''
    echo $'\e[1;36m::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::> \e[0m'
    echo $'\e[1;36m:: Vivaldi Profiles CLI :: \e[0m\e[1mProfiles List \e[1;36m:::>\e[0m'
    echo $'\e[1;36m::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::> \e[0m'
    echo $''
    echo $''
    for f in "${vpcli_path}/"*
    do
        local profile_name="${f##/*/}"
        [[ -d "$f" ]] && profile_text=$'\e[1m'"${profile_name}"$'\e[0m'
        if [[ $(isDefault "${profile_name}") == "1" ]]; then
            default_text="default"
            profile_text=$'\e[1;36m'"${profile_name}"$'\e[0m'
        fi
        echo ":: ${profile_text}   ${default_text}"
    done
    echo $''
    echo $'\e[1;36m::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::> \e[0m'
    echo $''
    exit 0
}

function copyProfile() {
    [[ -d "${1}" ]] || errorExit "Cannot copy profile. ${1} does not exist or is not a directory."

    if [[ -d "${2}" ]]; then
        read -p $'\e[93mWARNING::> '"Profile ${2} will be overwritten by ${1}. Are you sure? [y/n]"$'\e[0m ' -n 1 -r
        if [[ ! "${REPLY}" =~ ^[Yy]$ ]]; then
            echo $'\n'
            exit 0
        fi
    fi
    echo '\n'
    rsync -a "${1}/" "${2}/" || errorExit "Copying ${1} to ${2} FAILED";
}

#function backupProfile() {
    # TODO> Complete Backup as this function accepting 1 parameter - profile name.
    #rm -f "${vpcli_path}/.vpcli/defbak2.tgz" > /dev/null 2>&1
    #rm -f "${vpcli_path}/.vpcli/${vpcli_name}2.tgz" > /dev/null 2>&1
    #[[ -f "${vpcli_path}/.backup/defbak.tgz" ]] && mv "${vpcli_path}/.vpcli/defbak.tgz" "${vpcli_path}/.vpcli/defbak2.tgz"
    #[[ -f "${vpcli_path}/.vpcli/${vpcli_name}.tgz" ]] && mv "${vpcli_path}/.vpcli/defbak.tgz" "${vpcli_path}/.vpcli/${vpcli_name}2.tgz"
    #tar -zcvf "${vpcli_path}/.vpcli/defbak.tgz" "${vpcli_default}" || errorExit "Could not backup ${vpcli_default}!";
    #tar -zcvf "${vpcli_path}/.vpcli/${vpcli_name}.tgz" "${vpcli_profile}" || errorExit "Could not backup ${vpcli_profile}!";
#}

function makeDefault() {
    [[ ! -d "${vpcli_default}" ]] && errorExit "Default profile ${vpcli_default} does not exist or is not a directory. Update your Vivaldi Profiles CLI configuration."
    [[ ! -d "${vpcli_profile}" ]] && errorExit "You can only make an established profile the default. Please create ${vpcli_default} without the -d flag and then run this again."
    [[ $(isDefault "${vpcli_name}") || "${vpcli_name}" = "default" ]] && sendWarning "${vpcli_name} is already your default profile!" && return 0
    [[ $(pgrep "Vivaldi") ]] && errorExit "Please quit all instances of Vivaldi before setting the default profile!"

    local fq_default="${vpcli_path}/${vpcli_config_default}"
    #| Backup here if need be.
    #| Migrate default back to temp
    rm -rf "${vpcli_path}/.vpcli/temp/${vpcli_name}/" > /dev/null 2>&1
    rm -rf "${vpcli_path}/.vpcli/temp/${vpcli_config_default}/" > /dev/null 2>&1
    rsync -a "${vpcli_default}/" "${vpcli_path}/.vpcli/temp/${vpcli_config_default}/" || errorExit "Couldn't restore ${fq_default} to temp ${vpcli_path}/.vpcli/temp"
    rsync -a "${vpcli_profile}/" "${vpcli_path}/.vpcli/temp/${vpcli_name}/" || errorExit "Couldn't restore ${vpcli_profile} to temp ${vpcli_path}/.vpcli/temp"
    rm -f "${fq_default}" || errorExit "Could not remove the symlink from previous default: ${fq_default}"
    ln -s "${vpcli_default}" "${vpcli_profile}" || errorExit "Could not create symlink for ${vpcli_name} as default profile in ${vpcli_path}!"

    #| Update default
    rsync -a "${vpcli_profile}/" "${vpcli_default}/" || errorExit "Couldn't copy ${vpcli_profile}/ to ${vpcli_default} backup of old default available here: ${vpcli_path}/.vpcli/temp/${vpcli_config_default}/"

    #| Restore previous default as normal profile
    rsync -a "${vpcli_path}/.vpcli/temp/${vpcli_config_default}/" "${fq_default}/" || errorExit "Couldn't restore ${vpcli_path}/.vpcli/temp/${vpcli_config_default}/ to ${fq_default}/"

    #| Clean up and change settings
    echo "${vpcli_name}" > "${vpcli_path}/.vpcli/default" || errorExit "Could not edit the config file ${vpcli_path}/.vpcli/default"
    rm -rf "${vpcli_profile}" || errorExit "Could not remove the previous profile ${fq_default}"
    ln -s "${vpcli_default}" "${vpcli_profile}" || errorExit "Could not create symlink for ${vpcli_name} as default profile in ${vpcli_path}!"
}

vpcli_no_new=0
vpcli_make_default=0
vpcli_source=''
vpcli_name=''
[[ -f "${vpcli_path}/.vpcli/default" ]] && vpcli_config_default="$(cat "${vpcli_path}/.vpcli/default")"

for i in "$@"
do
    case $i in
        -l)
            listProfiles
            shift
        ;;
        -n)
            vpcli_no_new=1
            shift # past argument
        ;;
        -d)
            vpcli_make_default=1
            shift # past argument
        ;;
        -c)
            vpcli_source="${2//[[:blank:]]/}"
            shift # past argument
            shift # past value
        ;;
        *)
            vpcli_name="${1//[[:blank:]]/}"
        ;;
    esac
done

[[ -z ${vpcli_name} ]] && errorExit "You must provide a profile name"

[[ -n "${vpcli_config_default}" ]] && cpvli_name="${vpcli_config_default}"
vpcli_profile="${vpcli_path}/${vpcli_name}"

#| Check the profile's parent directory exists and create it if it doesn't.
if [[ ! -d "${vpcli_path}" ]]; then
    mkdir "${vpcli_path}" || errorExit "Could not create profile's parent directory ${vpcli_path}!"
fi

#| Check the default setting exists and create it if it doesn't.
if [[ ! -f "${vpcli_path}/.vpcli/default" ]]; then
    mkdir -p "${vpcli_path}/.vpcli/temp" || errorExit "Could not create config folder '${vpcli_path}/.vpcli'! This is important for changing defaults without loosing any data!"
    echo "original" > "${vpcli_path}/.vpcli/default" || errorExit "Could not create default setting file '${vpcli_path}/.vpcli/default'! This is important for changing defaults without loosing any data!"
    rsync -a "${vpcli_default}" "${vpcli_path}/.vpcli/temp/original/" || errorExit "Couldn't backup orginal profile to temp ${vpcli_path}/.vpcli/temp"
    ln -s "${vpcli_default}" "${vpcli_path}/default" || errorExit "Could not create symlink to default profile ${vpcli_default} in ${vpcli_path}!"
    ln -s "${vpcli_default}" "${vpcli_path}/original" || errorExit "Could not create symlink to original profile ${vpcli_default} in ${vpcli_path}!"
fi

#| -c | Copy: If this flag exists then copy from the specified profile.
[[ -n "${vpcli_source}" ]] && copyProfile "${vpcli_path}/${vpcli_source}" "${vpcli_profile}"

#| Check if profile folder exists and if one should be created
if [[ ! -d "${vpcli_profile}" ]]; then
    #| -n | No New: Do not create a new profile if this flag was set.
    if [[ ${vpcli_no_new} -eq 0 ]]; then
        mkdir "${vpcli_profile}" || errorExit "Could not create directory ${vpcli_profile}!"
    else
        errorExit "[ -n ] No New mode activated and ${vpcli_profile} doesn't exist!"
    fi
fi

#| -d | Default: Make this profile the default.
[[ ${vpcli_make_default} > 0 ]] && makeDefault

#| Load Vivaldi Instance
open -n -a /Applications/Vivaldi.app --args --user-data-dir="${vpcli_profile}" || errorExit "Something has gone terribly wrong! We couldn't open Vivaldi with your profile!"

exit 0;
