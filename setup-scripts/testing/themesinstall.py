"""
Use Python to read themes & URL, install with bash.
"""
import json
import os

themesfile = 'data/themes.json'
themesfolder = '/usr/share/themes/'
iconsfolder = '/usr/share/icons'
fontsfolder = '/usr/share/fonts'


def jsonload(f):
    """Loads a JSON file."""
    f = json.loads(f)
    print(f)


def jsonwrite(f):
    """Write data to JSON file."""
    data = []

    with open("f", "w") as write_file:
        json.dump(data, write_file)


def runshell(cmd):
    """Run a shell command, passed as 'cmd.'"""
    os.system(cmd)


def cmdbuild(x):
    """Build a command to be sent to runshell()."""
    cmd = ""  # i.e. "ls"
    os.system(cmd)  # i.e. os.system(cmd) = ls


jsonload(themesfile)
