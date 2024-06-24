{ pkgs, config, ... }:
{
  home.packages = with pkgs; [ gnome.nautilus gnome.weather simple-scan loupe ];

  services.syncthing = {
    enable = true;
    tray = {
      enable = true;
      command = "syncthingtray --wait";
    };
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-beta;
    profiles.TheStachelfisch = {
      id = 0;
      bookmarks = {};
      extensions = with config.nur.repos.rycee.firefox-addons; [
        ublock-origin
        keepassxc-browser
        clearurls
        return-youtube-dislikes
        darkreader
        enhancer-for-youtube
        fastforwardteam
        sponsorblock
      ];
      settings = {
        "browser.startup.page" = 3;
        "browser.download.panel.show" = true;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "dom.security.https_only_mode" = true;
        "privacy.trackingprotection.enabled" = true;
        "signon.rememberSignons" = false;
        "media.ffmpeg.vaapi.enabled" = true;
        "browser.safebrowsing.malware.enabled" = false;
        "app.shield.optoutstudies.enabled" = true;
        "datareporting.healthreport.uploadEnabled" = false;

        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
      };
      userContent = ''
        @import "firefox-macos-theme/Monterey/colors/light.css";
        @import "firefox-macos-theme/Monterey/colors/dark.css";

        @import "firefox-macos-theme/Monterey/pages/common.css";
        @import "firefox-macos-theme/Monterey/pages/newtab.css";
        @import "firefox-macos-theme/Monterey/pages/reader.css";
        @import "firefox-macos-theme/Monterey/pages/privatebrowsing.css";
      '';
      userChrome = ''
        /*------------------------USAGE----------------------------
        * Remove "/*" at the begining of "@import" line to ENABLE.
        * Add "/*" at the begining of "@import" line to DISABLE.
        */

        @import "firefox-macos-theme/Monterey/theme-alt.css"; /**/

        /*--------------Configure common theme features--------------*/

        /* Move tab close button to left. */
        /*@import "firefox-macos-theme/common/left-tab-close-button.css"; /**/

        /* Hide the tab bar when only one tab is open (GNOMISH)
        * You should move the new tab button somewhere else for this to work, because by
        * default it is on the tab bar too. */
        @import "firefox-macos-theme/common/hide-single-tab.css"; /**/

        /* Limit the URL bar's autocompletion popup's width to the URL bar's width (GNOMISH)
        * This feature is included by default for Firefox 70+ */
        @import "firefox-macos-theme/common/matching-autocomplete-width.css"; /**/

        /* Rounded window even when it gets maximized */
        /*@import "firefox-macos-theme/common/rounded-window-maximized.css"; /**/

        /* Active tab high contrast */
        /*@import "firefox-macos-theme/common/active-tab-contrast.css"; /**/

        /* Use system theme icons instead of Adwaita icons included by theme [BUGGED] */
        /*@import "firefox-macos-theme/common/system-icons.css"; /**/

        /* Allow drag window from headerbar buttons (GNOMISH) [BUGGED] */
        /* It can activate button action, with unpleasant behavior. */
        /*@import "firefox-macos-theme/common/drag-window-headerbar-buttons.css"; /**/

        /* Make all tab icons look kinda like symbolic icons */
        /*@import "firefox-macos-theme/common/symbolic-tab-icons.css"; /**/

        /* Hide window buttons (close/min/max) in maximized windows */
        @import "firefox-macos-theme/common/hide-window-buttons.css"; /**/
        .titlebar-spacer[type="post-tabs"]{ display:none }

        /* Import your custom stylesheet */
        /* @import "customChrome.css"; */
      '';
    };
  };

  home.file."firefox-macos-theme" = {
    target = ".mozilla/firefox/TheStachelfisch/chrome/firefox-macos-theme";
    source = "${(fetchTarball { url="https://github.com/TheStachelfisch/WhiteSur-firefox-theme/archive/fix-no-buttons.tar.gz"; sha256="0rn9k3g1ivvnhgkszwq4z30dsxq8ivlamnn5fh7qpz7n8jw4gnfn"; }) }/src"; 
  };

  services.psd = {
    enable = true;
    browsers = [ "firefox" "chromium" ];
    useBackup = false;
    backupLimit = 10;
  };
}
