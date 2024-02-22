# 2.0.0 (2024-02-22)

* Added: **Experimental** BTRFS snapshot support for the game installation
folder.
* Fixed: Unintended error message when the config file does not exist.

# 1.1.1 (2024-02-17)

* Fixed: Rogue `exit` statement left over from debugging breaking the overlay …

# 1.1.0 (2024-02-14)

* DEPRECATED: overlay hooks should no longer be placed in the installation
  folder of the scripts. They will still work, for now, and be executed _in
  addition_ to the hooks in the new default location.

* Added configuration file (see README). The scripts can now be used with the
  GOG (or any other) version of the game if the game paths are set in the
  configuration.
* Moved overlay hooks to the configuration folder.

# 1.0.0 (2023-11-26)

**BREAKING CHANGE**: Support for the “Script Extender” folder means you will
have to copy your “Script Extender” folder across profiles (or sym link it) if
you want to retain your Script Extender mods settings/data across profiles.

* Changing profile now also automatically runs `--link [PROFILE]` to make sure
  that additions like the Script Extender folder will not break existing
  profiles.
* Added `--link [PROFILE]` command. It will check for all required sym link, and
  create required folders that don’t exist in the given PROFILE. If no profile
  is given, checks the current one.
* Added support for the “Script Extender” folder. Many mods save their
  configuration there, and configuration files in this folder can have a huge
  impact on how the game plays. It should be per profile. You can still sym link
  the folder across profiles!

# 0.2.0 (2023-10-27)

* Modular loose files mods! Fuck yeah!

# 0.1.1 (2023-10-20)

* Fixed execution of pre and post hooks for `bg3overlay`.
* Fixed `bg3overlay` exiting with code `1` (error) when no post hook was found.
* Added additional string escaping, making the scripts more robust for Steam
  library paths containing spaces.

# 0.1.0 (2023-10-20)

* initial release
