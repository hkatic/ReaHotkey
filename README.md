# What's This And Who Is It For?
This is an AutoHotkey scripth which aims to make certain virtual instruments/sample libraries  and related programs at least a little more accessible to blind users. It is based on the accessibilityOverlay script available [here](https://github.com/MatejGolian/accessibilityOverlay/) and is primarily designed to run in tandem with the REAPER digital audio workstation, although in particular cases standalone versions of programs/instruments may be supported as well.

## Features
* Makes it possible to switch between the classic and modern mixes in Audio Imperia's Areia library.
  - Only works inside REAPER.
* Makes it possible to switch between the classic and modern mixes in Audio Imperia's Jaeger library.
  - Only works inside REAPER.
* Makes it possible to switch between the classic and modern mixes in Audio Imperia's Nucleus library.
  - Only works inside REAPER.
* Makes it possible to switch between the classic and modern mixes in Audio Imperia's Talos library.
  - Only works inside REAPER.
* Makes it possible to activate/deactivate multitracked guitars/basses in Impact Soundworks Shreddage-series instruments.
  - Only works inside REAPER.
* Makes it possible to load instruments and add libraries in Best Service Engine 2.
  - Works both inside REAPER and in the standalone version of Engine 2.

## Notes
Because ReaHotkey also passes through some keys to the application window itself, it's highly recommended to enable the 'Send all keyboard input to plug-in' option in REAPER's FX menu, when interacting with a supported plug-in interface.

## About HotspotHelper
HotspotHelper is a special utility to make developing these kind of scripts a little easier. It retrieves window and control info and creates labelled hotspots that can be copied to clipboard for subsequent use.
