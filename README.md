# Baldur’s Gate 3 Mod Profiles

[![basher install](https://www.basher.it/assets/logo/basher_install.svg)](https://www.basher.it/package/)

**This is _not_ a mod manager!** It is a collection of Bash scripts that can
manage separate sets of mods in conjunction with a mod manager like
[BG3 Mod Manager](https://github.com/LaughingLeader/BG3ModManager) or
[Lamp](https://github.com/CHollingworth/Lamp).

Well OK, at this point it’s _kind of_ a mod-manager-like thing for loose files
mods. Read on :)

## Features

* Store an arbitrary amount of profiles. Each of them contains distinct
  * "Mods" folders
  * "Script Extender" folders
  * Mod settings files
  * Loose files mods
* Create and switch between your profiles via shell script.
* Mount loose files mods into your game folder at runtime via overlayfs
* Keep loose files mods separate! No more “which files did that add⁈” when you
  want to uninstall one of them.
* **(Experimental)** Manage BTRFS snapshots of the game’s installation folder;
keep backups of old patches around!

## Installation

The overlay script depends on `fusermount`/`fuse-overlayfs`, so you will
probably want to install whatever package(s) provide(s) those for your
distribution.

Now install the scripts via Basher:

```bash
basher install git.alterNERD.tv/alterNERDtive/bg3-mod-profiles
```

(Github mirror: `basher install alterNERDtive/bg3-mod-profiles`)

or manually:

1. Clone this repository or grab an archive and extract it somewhere.
2. Symlink or copy `bg3overlay` and `bg3switch` into your `PATH`.

Next you need to change Baldur’s Gate 3’s launch options in Steam:

1. Right Click → Properties → General → Launch Options
2. Set it to `bg3overlay --enable && %command% ; bg3overlay --disable`. If
   you already had launch options set, don’t forget to keep them. If you
   did not add the scripts to your `PATH`, you need to add the full
   `/path/to/bg3overlay`.

You might also have to disable Steam Cloud Sync for the game.

To get started, you need to create at least one mod profile using `bg3switch
--create PROFILE`.

For the **experimental** snapshot support you will need to make sure beforehand
that your game installation folder is a valid BTRFS snapshot, e.g.:

```bash
> mv Baldurs\ Gate\ 3 tmpdir
> sudo bfrs sub create Baldurs\ Gate\ 3
> mv tmpdir/* !$
> rmdir tmpdir
```

Set your game to only update on launch, and make sure that you have activated
the snapshot of the current live version before you update your game. Otherwise
you **will** run into issues and have to verify your game files.

## Configuration

The configuration lives in `$XDG_CONFIG_HOME/bg3-mod-profiles/config` or
`~/.config/bg3-mod-profiles/config`.

| option | default | description |
|--------|---------|-------------|
| BG3_DATA_DIR | auto-detected for Steam | The game’s “%APPDATA%” folder. |
| BG3_INSTALL_DIR | auto-detected for Steam | The game’s installation folder. |

You can also create `bg3overlay.pre` and `bg3overlay.post` files in the
configuration folder. They will be executed before mounting and after unmounting
the overlay, respectively.

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

Alternatively, you can put loose files mods in their own subfolder of
`profiles/<name>/modular-override`:

```bash
> ls modular-override
'00-Visible Shields'           'Detailed Laezel'            'Karlach Vanilla Scars'  'Native Mod Loader'  'Shart Scars'
'Achievement Enabler'          'EA Loadscreens'             'Level 20'               'No Abs'
'Colorblind Spell Slots'       'Faster Rolls Quartered'     'More Detailed Halsin'    OIO
'Contextual Dialogue Buttons'  'Highlight Prepared Spells'  'Native Camera Tweaks'   'Script Extender'
```

Priority will be the `override` folder, then the modular overrides in
alphabetical order. I use this e.g. to keep my “Native Camera Mod” configuration
file in `override` and not have it overwritten by mod updates.

Profiles are stored under `%AppData%/Local/Larian Studios` within the game’s
proton prefix. You can easily access it by running `bg3switch --cd`.

## Usage

See [Configuration](#configuration), `bg3switch --help`, `bg3overlay --help`
and `bg3version --help`.

## How It Works

### Mod Profiles

`bg3switch` creates mod profiles in the `profiles` folder. Each profile consists
of a `Mods` folder, an `override` folder, and a `modsettings.lsx` file.

The `Mods` folder is straight up just what you would usually expect in the
`Baldur's Gate 3` subfolder and contains all the Mods’ `.pak` files.

The `override` folder contains all lose file mods that you would normally
extract directly into the game’s installation folder. They are overlaid onto it
at runtime.

The `modular-override` folder contains loose file mods, each in their own
folder. They are _each_ overlaid onto the game’s installation folder at runtime.
The big advantage of using this approach is being able to keep each mod’s files
separate.

Override priority is

1. The `override` folder. Put e.g. your settings file for the native camera mod
   here; it will have higher priority than the default file shipped with the mod
   then.
2. Modular overrides in alphabetical order.
3. Anything you manually change in the game’s installation folder. (Don’t do
   that, please.)

The `modsettings.lsx` file resides inside the same subfolder structure it would
normally (`PlayerProfiles/Public`). This makes zipping up your Mods – including
your modsettings file / load order – easier. Personally I use it for co-op
setups to make updating the mod list easier for the other players. _I_ update
everything, I zip it up, they just extract it.

The `Script Extender` folder contains anything you would usually find in
`Baldur's Gate 3/Script Extender`, e.g. the configuration file for [Zerd's Rules
As Written (RAW)](https://www.nexusmods.com/baldursgate3/mods/1329)

### Switching Mod Profiles

Switching mod profiles is the most trivial thing here. The `Mods` folder and
`modsettings.lsx` files are symbolically linked from `current` to the `Baldur's
Gate 3` folder.

`current` is just another symbolic link to the currently active profile. E.g.
the link structure for the `Mods` folder looks like this:

```bash
> stat -c "%N" -- Baldur\'s\ Gate\ 3/Mods
"Baldur's Gate 3/Mods" -> '../current/Mods'
> stat -c "%N" -- current
'current' -> './profiles/solo'
```

`Baldur's Gate 3/Mods` → `current/Mods` → `profile/<name>/Mods`

When switching mod profiles, the `current` symbolic link is updated to point to
the freshly activated / created profile. That’s it!

When you create your first profile, your current configuration is moved to the
profile and the symbolic links are set up automatically.

### Loading Loose File Mods at Runtime

`bg3overlay --enable` will mount an overlayfs to your game’s installation
folder. The folder itself will be temporarily renamed to `bg3base` in order to
be able to mount the overlay into `Baldurs Gate 3`, where Steam expects the
game.

The working directory and newly created files (the “upper” directory in
overlayfs terms) reside in `/tmp/bg3/`, which should usually be a RAM disk.

The benefit is that log files and crash dumps will not clutter your `override`
folder. The downside (or additional benefit) is that the files will disappear on
a reboot.

`bg3overlay --disable` will unmount the overlay and rename the game’s
installation folder back to `Baldurs Gate 3`.

## Troubleshooting

### The game doesn’t start after changing the launch options

Double check the launch options match the example. Run `bg3overlay --enable`
manually and see if it works.

If yes, run `bg3overlay --disable` and start looking elsewhere, because it’s not
my fault :)

If not, feel free to [file an
issue](https://github.com/alterNERDtive/bg3-mod-profiles/issues) and be
sure to attach the output.
