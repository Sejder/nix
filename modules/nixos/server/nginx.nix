{ config, pkgs, ... }:

{
  services.nginx = {
    enable = true;
    virtualHosts."nixos.tail3b396b.ts.net" = {

      locations."/" = {
        root = "/var/www/homepage/";
        index = "index.html";
      };

      locations."/test/" = {
        return = "200 '<html><body>It works but with test</body></html>'";
        extraConfig = ''
          default_type text/html;
        '';
      };

      locations."/immich/" = {
        proxyPass = "http://localhost:2283";
      };

      #"^~ /.well-known" = {
      #  priority = 9000;
      #  extraConfig = ''
      #    absolute_redirect off;
      #    location ~ ^/\\.well-known/(?:carddav|caldav)$ {
      #      return 301 /nextcloud/remote.php/dav;
      #    }
      #    location ~ ^/\\.well-known/host-meta(?:\\.json)?$ {
      #      return 301 /nextcloud/public.php?service=host-meta-json;
      #    }
      #    location ~ ^/\\.well-known/(?!acme-challenge|pki-validation) {
      #      return 301 /nextcloud/index.php$request_uri;
      #    }
      #    try_files $uri $uri/ =404;
      #  '';
      #};

      locations."/nextcloud/" = {
        priority = 9999;
        extraConfig = ''
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-NginX-Proxy true;
          proxy_set_header X-Forwarded-Proto http;
          proxy_pass http://localhost:8080/; # tailing / is important!
          proxy_set_header Host $host;
          proxy_cache_bypass $http_upgrade;
          proxy_redirect off;
        '';
      };
    };
  };

  environment.systemPackages = with pkgs; [
    nginx
  ];
}
