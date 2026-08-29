{
  flake.modules.homeManager.browser =
    { pkgs, ... }:
    {
      programs.firefox = {
        enable = true;
        package = pkgs.unstable.firefox;
        profiles.Ben = {
          id = 0;
          extensions = {
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              ublock-origin
              keepassxc-browser
              darkreader
              sponsorblock
              return-youtube-dislikes
              youtube-no-translation
              violentmonkey
              tweaks-for-youtube
            ];
          };
          settings = {
            "browser.aboutConfig.showWarning" = false; # about:config warning
            "browser.ml.chat.enabled" = false; # Sidebar AI Chat
            "browser.ml.chat.page" = false; # Sidebar AI Chat
            "browser.translations.neverTranslateLanguages" = "de";
            "browser.toolbars.bookmarks.visibility" = "always";
            "browser.contentblocking.category" = "strict";

            "browser.newtabpage.activity-stream.feeds.topsites" = false;
            "browser.newtabpage.activity-stream.newtabWallpapers.user.enabled" = true;
            "browser.newtabpage.activity-stream.newtabWallpapers.wallpaper" = "solid-color-picker-#000000";
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            "browser.newtabpage.activity-stream.showWeatherOptIn" = false;
            "browser.newtabpage.activity-stream.widgets.weather.enabled" = false;
            "browser.startup.page" = 3;

            "datareporting.healthreport.uploadEnabled" = false;
            "datareporting.usage.uploadEnabled" = false;

            "devtools.everOpened" = true;

            "dom.security.https_only_mode" = true;
            "dom.security.https_only_mode_ever_enabled" = true;
            "dom.private-attribution.submission.enabled" = false; # Ad measurment

            "findbar.highlightAll" = true;

            "privacy.fingerprintingProtection" = true;
            "privacy.query_stripping.enabled" = true;
            "privacy.query_stripping.enabled.pbmode" = true;
            "privacy.trackingprotection.enabled" = true;
            "privacy.trackingprotection.allow_list.convenience.enabled" = false;
            "privacy.trackingprotection.emailtracking.enabled" = true;
            "privacy.trackingprotection.socialtracking.enabled" = true;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.enabled" = false;
          };
        };
      };

      services.psd = {
        enable = true;
        backupLimit = 5;
      };
    };
}
