{ config, lib, pkgs, ... }:

with lib;

let
  ytdownload = pkgs.writeScriptBin "ytdownload" ''
    #!${pkgs.zsh}/bin/zsh
    set -e
    
    # Check if URL argument is provided
    if [ $# -eq 0 ]; then
      echo "Usage: ytdownload <youtube-url> [additional-yt-dlp-options]"
      echo "Example: ytdownload 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'"
      exit 1
    fi
    
    # Use uv to run yt-dlp with the provided arguments
    exec ${pkgs.uv}/bin/uvx --refresh yt-dlp "$@"
  '';
in
{
  options.features.scripts.ytdownloader = {
    enable = mkEnableOption "Enable ytdownload script for downloading YouTube videos with yt-dlp via uv";
  };

  config = mkIf config.features.scripts.ytdownloader.enable {
    home.packages = with pkgs; [
      ytdownload
      uv
      ffmpeg_6-full
    ];
  };
}