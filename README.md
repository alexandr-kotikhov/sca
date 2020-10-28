# sca

Create an environment to write and invoke bash scripts usefully.

## Purpose

Very often during development or administration, there is a need to automate some tasks.
Obviously, on Linux you can successfully do this with bash scripts. 
Then you need to register these scripts as a command alias or change the PATH for
each such scenario is not the most pleasant experience.
Scripting is not the easiest thing to do, this scripting system enforces the "good" style 
of writing such scripts and provides help, action choices and autocomplete options.

## Installation

Create any directory (for example `$HOME/sca`) and load the scripts into it.
Then add line `source $HOME/sca/sca_register.sh` to ~/.bashrc that registers these scripts.

~~~
mkdir $HOME/sca 
cd $HOME/sca
wget 'https://github.com/alexandr-kotikhov/sca/archive/master.zip'
unzip -j master.zip
rm -f master.zip
echo "source $HOME/sca/sca_register.sh" >> ~/.bashrc
~~~

## Usage


## How it works

Sca scans all directories from the current to the root of the file system and also in the user's home folder for
presence of scripts in sub-folders `.sca`. If it encounters a file there without an extension, 
it interprets the found file as a custom script. Then sca analyzes its contents and looks for functions there 
that have names starting with `cmd_`. The scripts and functions found will be the script and action, 
which are then run by sca.

 