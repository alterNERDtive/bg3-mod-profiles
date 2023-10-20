# Baldur’s Gate 3 Mod Profiles

**This is _not_ a mod manager!** It is a collection of Bash scripts that can
manage separate sets of mods in conjunction with a mod manager like
[BG3 Mod Manager](https://github.com/LaughingLeader/BG3ModManager) or
[Lamp](https://github.com/CHollingworth/Lamp).

## Features

* Store an arbitrary amount of profiles. Each of them contains distinct
    * "Mods" folders
    * Mod settings files
    * Loose files mods
* Create and switch between your profiles via shell script.
* Mount loose files mods into your game folder at runtime via overlayfs

## Installation

1. Install whatever package(s) provide(s) `fusermount` and `fuse-overlayfs` for
    your distribution.
2. Clone this repository or grab an archive and extract it somewhere.
3. Optional: add `bg3overlay` and `bg3switch` to your `PATH`.
4. Optional: create `bg3overlay.pre` and `bg3overlay.post` files. They will be
    executed before mounting and after unmounting the overlay, respectively.
5. Create a new mod profile using `bg3switch --create PROFILE`.
6. Change Baldur’s Gate 3’s launch options in Steam:
    1. Right Click → Properties → General → Launch Options
    2. Set it to `bg3overlay --enable && %command% ; bg3overlay --disable`. If
        you already had launch options set, don’t forget to keep them. If you
        did not add the scripts to your `PATH`, you need to add the full
        `/path/to/bg3overlay`.

## Installing / Updating Mods

To install or update mods in a certain profile, first switch to that profile if
it isn’t already active: `bg3switch PROFILE`. Now you can use the mod manager of
your choice to install, remove or update mods. Of course you can also still do
it manually.

To install loose files mods, do _not_ extract them into the game folder
directly! We want to keep those separate per profile. Instead install them into
the `override` subfolder of your profile. This not only means no accidental
mixups between profiles, but also that uninstalling / reinstalling / verifying
/ updating the game files does not affect your loose files mods in any way.

Profiles are stored under `%AppData%/Local/Larian Studios` within the game’s
proton prefix. You can easily access it by running `bg3switch --cd`.

## Usage

See [Installation](#installation), `bg3switch --help` and `bg3overlay --help`.

## Troubleshooting

### The game doesn’t start after changing the launch options.

Double check the launch options match the example. Run `bg3overlay --enable`
manually and see if it works.

If yes, run `bg3overlay --disable` and start looking elsewhere, because it’s not
my fault :)

If not, feel free to
[file an issue](https://github.com/alterNERDtive/bg3-mod-profiles/issues) and be
sure to attach the output.
