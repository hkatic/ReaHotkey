# ReaHotkey

## What's This And Who Is It For?
This is an AutoHotkey scripth which aims to make certain virtual instruments/sample libraries  and related programs at least a little more accessible to blind users. It is based on the accessibilityOverlay script available [here](https://github.com/MatejGolian/accessibilityOverlay/) and is primarily designed to run in tandem with the REAPER digital audio workstation, although in particular cases standalone versions of programs/instruments may be supported as well.

## Features
* Makes it possible to load instruments and add libraries in Best Service Engine 2.
  - Works both inside REAPER and in the standalone version of Engine 2.
* Makes it possible to interact with Komplete Kontrol menus.
  - Works both inside REAPER and in the standalone version of Komplete Kontrol. Note that Komplete Kontrol version 3 is required.
* Makes it possible to interact with Kontakt menus.
  - Works both inside REAPER and in the standalone version of Kontakt. Note that Kontakt version 7.7.0 or higher is required.
* Makes it possible to switch Between various mixes in Audio Imperia's Areia, Cerberus, Chorus, Jaeger, Nucleus, Solo and Talos libraries.
  - Only works inside REAPER.
* Makes it possible to load instruments and add libraries in Best Service Engine 2.
  - Works both inside REAPER and in the standalone version of Engine 2.
* Enables accessibility for Dubler 2.2 by Vochlea
  - only standalone support for now
  - not all features are supported, nor do we know if they ever will be (see [below](#dubler2))

## General Notes
* Because ReaHotkey also passes through some keys to the application window itself, it's highly recommended to enable the 'Send all keyboard input to plug-in' option in REAPER's FX menu, when interacting with a supported plug-in interface.
* In order to make ReaHotkey work successfully with a certain application such as REAPER, ReaHotkey should be run with at least the same user privileges as the application to be controlled, otherwise ReaHotkey keyboard commands may not function correctly. For instance, if you are running REAPER as administrator, you should run ReaHotkey as administrator as well.

## <a name="dubler2"></a>Dubler 2 Accessibility

We try to make as many features of Dubler 2 accessible through ReaHotkey.

### Accessible Features

This is a rather incomplete list of features we already support.

* [Create and load profiles](#dubler2-profiles)
* Built-in audio controls like enable/disable and synth preset control
* Enable/disable MIDI output
* Full trigger support, including creation, renaming, deletion, recording and more
* Full pitch and pitch bend support
* Basic chords support, including enable/disable, voicing control and octave shifting
* Vowel envelopes are entirely configurable
* Audio Calibration support to use other microphones other than the Dubler Microphone

### Inaccessible Features

The following list also is a rather incomplete list of features that aren't currently supported, but we're aware of and might happen in the future.

* Extended chords support, like building custom chords presets
* Dubler Companion Plug-in is currently not accessible
* User account settings aren't accessible
* Some random pop-ups might not be accessible and disturb the workflow. Please let us know if you encounter one and tell us how to make them appear so that we can add support for them.

### <a name="dubler2-profiles"></a>About profiles in Dubler 2

ReaHotkey allows you to create as many profiles as you want. It however only allows you to load one of the first 5 profiles in the list of all profiles, which therefore get suffixed with a tag that indicates if its an active profile which can be loaded, or a passive one which needs to be moved to an active slot first.
This is not how Dubler 2 behaves in general, but its a limitation we have to put onto the script because of how the GUI is designed. Thus, in order to make a profile loadable which isn't currently amongst the 5 active profiles, you'll have to push its button and use the move menu to switch it with a currently active profile. This process will restart Dubler for the changes to take effect. Just wait a few seconds until Dubler opens up again and you will be able to load the profile just fine.

## Keyboard Shortcuts
* ctrl+shift+windows+a - about
* ctrl+shift+windows+p - pause
* ctrl+shift+windows+q - quit
* ctrl+shift+windows+r - view readme

## Known Issues

* The ReaHotkey script can crash while In Dubler 2 audio calibration view. In that case just start the script again.
* If you find that your keyboard or ReaHotkey itself is not responding as expected after interacting with Kontakt menus, press the Escape key.
* Using any other zoom value in Kontakt than 100% may result in ReaHotkey not working correctly and the Kontakt plugin not being detected.

## About HotspotHelper
HotspotHelper is a special utility to make developing these kind of scripts a little easier. It retrieves window and control info and creates labelled hotspots that can be copied to clipboard for subsequent use.
