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
