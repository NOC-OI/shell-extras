# Bash Configurations Demystified
.bash_profile, .profile, & .bashrc Conventions

Bash configurations on Linux and OS X can be confusing for many people, myself included. I've written this short guide to remind you and I both of a reasonable set of conventions you could follow.
Login Shell vs. Non-login Shell

When logging in via the console (e.g., an SSH session, the scary console login after you've messed up your GUI settings, etc.), you are starting a login shell. If you open a terminal application (e.g. xterm, etc.) from your desktop, then you are starting a non-login shell (except on OS X, discussed later).
Linux (Ubuntu specifically)

On a clean install of Ubuntu, you'll notice your home directory contains both a .profile and .bashrc file. Starting a login shell executes .profile and starting a non-login shell executes .bashrc. Notice that inside .profile you'll find
```
# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
```
This means that login shells execute .profile and then source .bashrc, while non-login shells execute .bashrc only.

![](assets/ubuntu_bash_diagram.png)

Be Aware (if you add a .bash_profile)

You should also be aware that to start a login shell bash looks for .bash_profile, .bash_login, and .profile in that order and it only reads and executes the first one it finds. By default, the first two are not present on Ubuntu. Programs like RVM add a .bash_profile file so you should be sure to append

    [[ -s ${HOME}/.profile ]] && source ${HOME}/.profile

to the added .bash_profile file. (After installing RVM you might have noticed that ls colorization disappeared from login shells as a result of .bashrc no longer being sourced since .profile was ignored; this should resolve those issues). Sourcing .profile means that now, every time you start a login shell .bash_profile is executed, then .profile, and finally .bashrc. Starting a non-login shell will just execute .bashrc as before.
Mac OS X

On a clean install of OS X, you should have a .bashrc file and a .bash_profile file. Unlike most of the Unix/Linux world, OS X terminal applications (e.g. Terminal, iTerm2, etc.) start a login shell. So whether you SSH into an OS X machine or launch a terminal application, bash will launch as a login shell. While Ubuntu makes use of .profile by default, OS X chose to use .bash_profile (and no .profile file), which takes precedence on the list given above. Inside the .bash_profile on OS X, you'll find something like

    [[ -s ~/.bashrc ]] && source ~/.bashrc

Just as Ubuntu's .profile sourced .bashrc, OS X's .bash_profile sources .bashrc too. On OS X, whether you login via a GUI and open a terminal application, SSH in, or login at a console, you'll be starting a login shell which will execute .bash_profile and then source .bashrc.

![](os_x_bash_diagram.png)

## Where do I make changes?

Whether you use Linux or OS X, any bash-related changes, such as adding aliases, functions, or tweaking the prompt appearance can be appended to .bashrc. If you've set up sourcing as described above, .bashrc is executed in both login and non-login shells on both Linux and Mac OS X.

Another related option is to append

    [[ -s ${HOME}/.local.bash ]] && source ${HOME}/.local.bash

to .bashrc and then make all further bash customization changes to .local.bash. This seems to be common on company issued machines since admins don't like users mucking around with .bashrc. If this is the case for you, then make your bash config changes to .local.bash.
When NOT to modify .bashrc?

As the name implies, .bashrc is for bash configs. Environment variables or other configuration settings should typically be written to .profile on Ubuntu and .bash_profile on OS X. A common desire is to extend the PATH variable:

````
# Add path to Python scripts directory
PATH=/usr/local/share/python:$PATH
````

On Linux, you would append this path extension to your .profile, unless you've set up a .bash_profile that sources .profile which then sources .bashrc (just choose a strategy and be consistent). Logging into your machine again, every terminal session will have the PATH you defined. This happens because .profile (or .bash_profile) is executed at login, before any non-login shells are started. I do most of my PATH modifications when first configuring a machine, so it is no problem to apply changes at the next login. If you need to apply your change now, in your current non-login shell, you could:

    source ~/.profile      # or ~/.bash_profile

On OS X, you should add the line to .bash_profile, although you could optionally set up .bash_profile to source .profile and .bashrc for symetry with Ubuntu and put the line in .profile.
Errors

If you find any errors or have any suggestions, please kindly contact me at @dghubble or by email at dghubble@gmail.com. I'll keep this updated reference.
