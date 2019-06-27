TessuMod TeamSpeak Plugin for World of Tanks
============================================

This plugin is part of a TessuMod game modification for World of Tanks game,
and will not work without it. The plugin provides 3D positional audio.

See the modification here:
  https://github.com/jhakonen/wot-teamspeak-mod/

This plugin is available for download in myteamspeak.com at:
  https://www.myteamspeak.com/addons/01a0f828-894c-45b7-a852-937b47ceb1ed

Building on Windows
-------------------
You will need following dependencies:
* Visual Studio 2015
* Python 2.7
* Qt 5.12.3

Open Command Prompt and then build the installer:

```batch
set PATH=C:\Qt\Qt5.12.3\5.12.3\msvc2015_64\bin;C:\Python27;%PATH%
"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64 8.1
mkdir build
cd build
qmake ..
nmake package
```

Adjust the paths to match your environment.

Building on Linux (e.g. Ubuntu)
-------------------------------

```bash
sudo apt install qt5-default

mkdir build
cd build
qmake ..
make package
```

License
-------
This mod is licensed with LGPL v2.1.

Development
-----------
With bugs and improvement ideas please use [issues page](https://github.com/jhakonen/wot-teamspeak-plugin/issues) to report them.
Also, pull requests are welcome. :)
