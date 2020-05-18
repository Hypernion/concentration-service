# About

I'm a big fan of [Concentration](https://pypi.org/project/concentration/). It's a pip package that writes automatically to your /etc/hosts file to block websites you find distracting from a list you generate. It makes that tool available in console with simple commands "concentration improve" and "concentration lose". Its primary purpose is preventing procrastination and keep your work hours productive. It comes in especially useful if working from home or your laptop because a constant block (say, at router level) would eat into your fun after work hours.

The problem with tools like concentration is that you need to have the self-discipline to run those commands yourself during work hours and sometimes you've already opened /r/kittens on boot. Next thing you know it's bedtime and you've got nothing done. Simple solution: **run it as a service.**

Now, you may be able to figure out a way around it (and you will, as root) - but as a tool to prevent procrastination it is supposed to present further barriers to distractions; which it does. 

## Installation

#### 1. Install concentration and its dependencies.

**Arch/Manjaro**

*You may not need to run as sudo if you're not using sudo. Default version of Python is 3 for Arch*

`sudo pacman -S python python-pip`

`sudo pip install concentration`

**Ubuntu/Debian**

*Check Python is Version 3*

`sudo python3 --version`

*install pip3*

`sudo apt-get install python3 python3-pip`

`sudo pip3 install concentration`

#### 2. Clone or download this repository somewhere sensible on your computer and move into the directory

`git clone https://github.com/Hypernion/concentration-service.git`

`cd concentration-service`

#### 3. Make the concentration.sh file executable

`sudo chmod +x concentration.sh`

#### 4. Alter LOCATION to the path of concentration.sh file on your machine. 

`sed -r -i 's+LOCATION+/your/file/concentration.sh+g' concentration.service`

**or**, if you prefer, open with your favourite text editor and change `LOCATION` to /your/path/concentration.sh 

`sudo nano ./concentration.service`

#### 5. Copy the service file and timer file to your systemd

`sudo cp concentration.service /etc/systemd/system/concentration.service && sudo cp concentration.timer /etc/systemd/system/concentration.timer`

#### 6. Set your preferred TimeOff and TimeOn

`sed -r -i 's+TimeOn=8+TimeOn=YOURNUMBER+g' concentration.sh`

`sed -r -i 's+TimeOff=18+TimeOff=YOURNUMBER+g' concentration.sh`

**or**, open with your favourite text editor and change `TimeOff=8` and `TimeOn=18` to your preferred hours. 

`sudo nano ./concentration.service`

**Please note: use single digits for hours less than 10 only. Write "8" not "08".**

Defaults are sanely set to 8 (AM) and 18 (6PM) to cover a normal work day, so you may not want to bother with this step.

#### 7. Set up Concentrations Distraction Lists

[Visit the project here to learn how to set up distraction lists](https://pypi.org/project/concentration/). The default list will block most social media and news sites, however. 

#### 8. Reload the Daemons, Enable and start the timer.

`sudo systemctl daemon-reload && sudo systemctl enable concentration.timer && sudo systemctl start concentration.timer`

## Strict Enforcement

You may want to add another layer of difficulty by removing access to concentration's commands that allow you manually start, stop or break it if adhering to strict enforcement. You can do this by editing your /etc/sudoers or /etc/sudoers.d/ if you're using sudo. For example adding:

`your_username ALL=/usr/bin, !/usr/bin/concentration`

Of course, this can be circumvented easily. Honestly at the point you've stopped a service, edited your sudoers file and then switched off concentration, you probably need to have a long talk with yourself (Why are you like this, anyway?). 

You may also want to stop yourself from easily editing the script by changing its owner and file permissions, and/or moving it out of the home directory. 

# FAQ

### How do I add/remove websites
[Please reference concentration's documentation for how to add/remove websites from your distraction lists](https://pypi.org/project/concentration/). All this repository really contains is a bash script, service file and instructions for people who might be beginners - under the hood it's all concentration. The default blocks are pretty good too - most social media sites etcetera.

### It doesn't work on my install, why?
 This method depends on systemd and bash; so it should be fine for most linux distributions but I suppose if your distro doesn't use systemd you might have trouble (Gentoo, Alpine?). In case you're without systemd you could try scheduling the same script with cronjob?

### Doesn't this waste resources running as a service?
I really don't imagine there'll be any issue. The script checks if a file exists in /tmp/ before running any python and editing /etc/hosts/. It also waits 10 minute intervals to do its checks. On my system it was using ~1M of memory. Don't worry about it.

### I want to edit my work hours because I'm a nightowl now.
Edit the `TimeOn` and `TimeOff` variables in concentration.sh script. Your new hours will then run on your next check.

### I enabled it but can still see websites I blocked.
Force refresh your page or double check you've followed concentration's instructions for setting up your block files. 

### I manually switched off concentration and now the service thinks it's in an active state.
This happens because to avoid uneccessary editing of the host file and calling of the python code; the bash script looks for a file in /tmp/ which indicates concentration was already at the correct time. Just reactivate concentration with `sudo concentration improve` and everything will go back to normal. Alternatively delete that tmp file `sudo rm /tmp/concentration_state_active`. You can also restart your computer or wait till the next active time period. You could also follow the advice above in the "strict enforcement" section.  