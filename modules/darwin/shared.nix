{
  inputs,
  pkgs,
  ...
}: {
  system.defaults.finder.AppleShowAllFiles = true;

  # Keep /run alive (needed by some simulators)
  # system.enableLaunchd = true;
}
