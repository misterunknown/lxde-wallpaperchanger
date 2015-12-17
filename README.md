# lxde-wallpaperchanger
This script changes the wallpaper after a configurable period of time

## requirements
* LXDE
* pcmanfm (must handle the wallpaper)
* bash ($RANDOM required)

## functions
The script can handle the following signals:

| signal  | effect                           |
|---------|----------------------------------|
| SIGUSR1 | next wallpaper                   |
| SIGHUP  | reload image list from IMAGE_DIR |

You can send a signal simply by using the kill command (all examples send SIGUSR1):

```bash
kill -SIGUSR1 <PID>
kill -USR1 <PID>
kill -10 <PID>
```

## configuration
The following bash variables can be set directly in the script or using a config file (~/.config/wallpaperchanger.conf). You have to follow the correct bash syntax (without spaces around the equal sign, e.g. VAR=VAL).

| option     | default value                 | description                                      |
|------------|-------------------------------|--------------------------------------------------|
| IMAGE\_DIR | /home/marco/Bilder/wallpaper  | directory which contains the wallpapers          |
| TIMEOUT    | 900                           | time in seconds after the wallpaper gets changed |
| SHUFFLE    | 1                             | level of randomness: <br> 0 => in order <br> 1 => random order, no duplicates <br> 2 => completely random |
| LOGFILE    | ${HOME}/.wallpaperchanger.log | path to log file                                 |


## license
This script is provided unter the terms of the [MIT license](license.md).
