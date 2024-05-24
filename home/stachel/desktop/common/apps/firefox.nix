{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ profile-sync-daemon ];
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
      };
    };
  };
  services.psd = {
    enable = true;
  };
}
