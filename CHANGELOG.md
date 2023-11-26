# devel

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
