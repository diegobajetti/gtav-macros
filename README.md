# — GTA Online Macros —

This repository houses an AutoHotKey macro crafted for GTA Online. In addition to common macros like armor, snacks, and BST, there are functions to disable PC internet access and block connection to R\* servers.

## Downloading

### GitHub Download

Download the [`.ahk` script](https://github.com/diegobajetti/gtav-macros/blob/main/gtav_macros.ahk) by cliking the download button on the top right. The script can be installed anywhere on the computer, including the start menu folder as outlined [below](#-initial-setup).

### Clone the Repo

Alternatively, clone the repo for contributing purposes.

1. Navigate to the desired directory where the project will be stored.

1. Clone the repository by executing the following command.

   ```bash
   git clone git@github.com:diegobajetti/gtav-macros.git
   ```

## Initial Setup

Certain functions of the script require it be run with administrator privileges. To execute an AutoHotKey script with administrator privileges, the following code has been included.

```ahk
if not A_IsAdmin
  Run *RunAs "%A_ScriptFullPath%"
```

Ideally, this script should run on machine startup. Running the script before launching the game is acceptable but prone to a UAC prompt requesting administrator privileges, shifting window focus away from GTA or any other application. Another script is currently under development which will run on PC startup and call the GTAV macro script whenever it detects that `gta.exe` has been launched.

The hotkeys in the script are only executed whenever the game has been launched.

```ahk
#IfWinActive ahk_class grcWindow
```
