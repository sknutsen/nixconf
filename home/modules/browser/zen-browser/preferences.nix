{
  config,
  inputs,
  pkgs,
  ...
}: {
  programs.zen-browser.policies.Preferences = {
    "zen.glance.enabled" = {
      "Value" = false;
      "Status" = "locked";
    };
    "zen.view.compact.hide-toolbar" = {
      "Value" = true;
      "Status" = "locked";
    };
    "zen.view.compact.should-enable-at-startup" = {
      "Value" = false;
      "Status" = "locked";
    };
    "zen.view.show-newtab-button-border-top" = {
      "Value" = true;
      "Status" = "locked";
    };
    "zen.view.show-newtab-button-top" = {
      "Value" = false;
      "Status" = "locked";
    };
    "zen.view.use-single-toolbar" = {
      "Value" = false;
      "Status" = "locked";
    };
  };
}
