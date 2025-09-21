{ config, lib, pkgs, ... }:

with lib;

let
  ytdownload = pkgs.writeScriptBin "ytdownload" ''
    #!/${pkgs.zsh}/bin/zsh
    set -e
    
    # Check if URL argument is provided
    if [ $# -eq 0 ]; then
      echo "Usage: ytdownload <youtube-url> [additional-yt-dlp-options]"
      echo "Example: ytdownload 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'"
      exit 1
    fi
    
    # Create temporary Videos directory in current working directory
    mkdir -p ./Videos
    
    # Download video to ./Videos
    ${pkgs.uv}/bin/uvx --refresh yt-dlp -o "./Videos/%(title)s.%(ext)s" "$@"
    
    # Move downloaded files to Nextcloud via rclone
    rclone move ./Videos/ cloud:/Videos/ --verbose
    
    # Clean up - remove the temporary Videos directory
    rm -rf ./Videos
  '';
in
{
  options.features.scripts.ytdownloader = {
    enable = mkEnableOption "Enable ytdownload script for downloading YouTube videos with yt-dlp via uv and moving to Nextcloud via rclone";
  };

  config = mkIf config.features.scripts.ytdownloader.enable {
    home.packages = with pkgs; [
      ytdownload
      uv
      ffmpeg_6-full
      rclone
    ];
  };
}
