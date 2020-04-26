# TessuMod: Mod for integrating TeamSpeak into World of Tanks
# Copyright (C) 2014  Janne Hakonen
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301
# USA

PLUGIN_NAME        = "TessuMod Plugin"
PLUGIN_DESCRIPTION = "This plugin provides support for 3D audio, with help of TessuMod, it positions users voice in TeamSpeak so that their voices appear to come from their vehicle's direction on battlefield."
PLUGIN_AUTHOR      = "Janne Hakonen (jhakonen @ WOT EU server)"

# Plugin version is usually provided from Github Actions workflow
!defined(PLUGIN_VERSION, var):PLUGIN_VERSION = "development"

TARGET = tessumod_plugin
TEMPLATE = lib
QT += widgets
CONFIG += C++11

# In Linux remove 'lib' prefix from the output library and do not create
# versioned symbolic links to it. MSVC doesn't do such stuff, so that doesn't
# require these configs.
linux:CONFIG += no_plugin_name_prefix plugin

# Convert compiler warnings to build failing errors
linux:QMAKE_CXXFLAGS += -Werror

# PLUGIN_PLATFORM must be one of the supported architecture types listed here:
#     https://forum.teamspeak.com/threads/65214-TeamSpeak-3-Package-Installer
win32 {
	contains(QT_ARCH, x86_64) {
		PLUGIN_PLATFORM = win64
	} else {
		PLUGIN_PLATFORM = win32
	}
} else {
	contains(QT_ARCH, x86_64) {
		PLUGIN_PLATFORM = linux_amd64
	} else {
		PLUGIN_PLATFORM = linux_x86
	}
}

# Compile release library with debugging symbols
QMAKE_CFLAGS_RELEASE += $$QMAKE_CFLAGS_RELEASE_WITH_DEBUGINFO
QMAKE_CXXFLAGS_RELEASE += $$QMAKE_CXXFLAGS_RELEASE_WITH_DEBUGINFO
QMAKE_LFLAGS_RELEASE += $$QMAKE_LFLAGS_RELEASE_WITH_DEBUGINFO

# Ensure that the final library is in a obvious location
DESTDIR = "$${OUT_PWD}/output"

win32 {
	DEBUG_SYMBOLS_EXTENSION = pdb
	LIBRARY_EXTENSION = dll
} else {
	DEBUG_SYMBOLS_EXTENSION = debug
	LIBRARY_EXTENSION = so
}


TARGET_FILE_PATH = "$${DESTDIR}/$${TARGET}.$${LIBRARY_EXTENSION}"
DEBUG_FILE_PATH = "$${DESTDIR}/$${TARGET}.$${DEBUG_SYMBOLS_EXTENSION}"

# Strip debug symbols and save them to a separate file. Only required in Linux
# as MSVC in Windows can create the separate file by itself.
linux:QMAKE_POST_LINK = "$$PWD/bin/strip-symbols" "$${TARGET_FILE_PATH}" "$${DEBUG_FILE_PATH}"

# In Linux with g++ the qmake creates makefile for release build only, thus
# 'all' target builds the library. In Windows with MSVC the qmake creates two
# makefiles for both release and debug builds, and there 'all' would build both
# types, thus 'release' target is required instead. Linux's makefile doesn't
# have 'release' target.
linux:BUILD_TARGET = all
win32:BUILD_TARGET = release

# Target for creating a compressed archive with the debugging symbol file
# included, usefull for debugging crashes
debugsymbols.target = "$${OUT_PWD}/$${TARGET}_$${PLUGIN_VERSION}_$${PLUGIN_PLATFORM}_dbg.zip"
debugsymbols.depends = $$BUILD_TARGET
debugsymbols.commands = python $$PWD/bin/make-dbg-archive.py "$${debugsymbols.target}" "$${DEBUG_FILE_PATH}"

# Tell Github actions workflow where the debug symbols artifact is
debugsymbols.commands += "&& echo ::set-output name=debugsymbols-artifact::$${debugsymbols.target}"

# Target for creating .ts3_plugin installer file, allows easy install of the
# plugin by the end user. This should be the one that is uploaded to myteamspeak.com
ts3_plugin.target = "$${OUT_PWD}/$${TARGET}_$${PLUGIN_VERSION}_$${PLUGIN_PLATFORM}.ts3_plugin"
ts3_plugin.depends = $$BUILD_TARGET
ts3_plugin.commands = python $$PWD/bin/make-installer.py \
	"$${ts3_plugin.target}" \
	"$$OUT_PWD/installer_files" \
	"$$OUT_PWD/etc/package.ini" \
	"$${TARGET_FILE_PATH}" \
	"$$PWD/audio/testsound.wav" \
	"$$PWD/etc/alsoft.ini" \
	"$$PWD/etc/hrtfs/*.mhr"
win32:ts3_plugin.commands += "$$PWD/bin/OpenAL64.dll"

# Tell Github actions workflow where the plugin artifact is
ts3_plugin.commands += "&& echo ::set-output name=plugin-artifact::$${ts3_plugin.target}"

# Umbrella target for creating both installer and associated debugging symbols
package.target = package
package.depends = $${ts3_plugin.target} $${debugsymbols.target}

QMAKE_EXTRA_TARGETS += package ts3_plugin debugsymbols

QMAKE_CLEAN += \
	"$${DEBUG_FILE_PATH}" \
	"$${TARGET_FILE_PATH}" \
	"$${ts3_plugin.target}" \
	"$${debugsymbols.target}"

INCLUDEPATH += include $$OUT_PWD/src

SOURCES += \
	src/ui/settingsdialog.cpp \
	src/entities/settings.cpp \
	src/entities/user.cpp \
	src/entities/vector.cpp \
	src/entities/camera.cpp \
	src/usecases/usecasefactory.cpp \
	src/usecases/usecases.cpp \
	src/storages/userstorage.cpp \
	src/storages/camerastorage.cpp \
	src/adapters/audioadapter.cpp \
	src/adapters/voicechatadapter.cpp \
	src/adapters/gamedataadapter.cpp \
	src/storages/adapterstorage.cpp \
	src/storages/settingsstorage.cpp \
	src/drivers/inisettingsfile.cpp \
	src/drivers/openalbackend.cpp \
	src/drivers/teamspeakplugin.cpp \
	src/drivers/wotconnector.cpp \
	src/adapters/uiadapter.cpp \
	src/main.cpp \
	src/utils/logging.cpp \
	src/utils/positionrotator.cpp \
	src/utils/wavfile.cpp \
	src/utils/async.cpp \
	src/entities/failures.cpp \
	src/openal/proxies.cpp \
	src/openal/openal.cpp \
	src/openal/structures.cpp \
	src/openal/privateimpl.cpp

HEADERS +=\
	src/ui/settingsdialog.h \
	src/entities/settings.h \
	src/entities/user.h \
	src/entities/vector.h \
	src/entities/camera.h \
	src/usecases/usecasefactory.h \
	src/usecases/usecases.h \
	src/interfaces/storages.h \
	src/interfaces/usecasefactory.h \
	src/interfaces/adapters.h \
	src/storages/userstorage.h \
	src/storages/camerastorage.h \
	src/interfaces/drivers.h \
	src/adapters/audioadapter.h \
	src/adapters/voicechatadapter.h \
	src/adapters/gamedataadapter.h \
	src/storages/adapterstorage.h \
	src/storages/settingsstorage.h \
	src/drivers/inisettingsfile.h \
	src/drivers/openalbackend.h \
	src/drivers/teamspeakplugin.h \
	src/drivers/wotconnector.h \
	src/adapters/uiadapter.h \
	src/entities/enums.h \
	src/utils/logging.h \
	src/utils/positionrotator.h \
	src/utils/wavfile.h \
	src/utils/async.h \
	src/entities/failures.h \
	src/openal/proxies.h \
	src/openal/openal.h \
	src/openal/structures.h \
	src/openal/privateimpl.h

FORMS += \
	src/ui/settingsdialog.ui

QMAKE_SUBSTITUTES += \
	src/config.h.in \
	etc/package.ini.in

DISTFILES += \
	src/config.h.in
