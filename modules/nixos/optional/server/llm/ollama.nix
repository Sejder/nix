{
  config,
  lib,
  ...
}: let
  cfg = config.features.server.llm.ollama;
in {
  options.features.server.llm.ollama = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Ollama";
    };
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
      loadModels = ["llama3.2" "deepseek-r1" "mistral" "qwen3" ];
      user = "ollama";
      group = "ollama";
      port = 11434;
    };
    services.open-webui = {
      enable = true;
      port = 11111;
    };

    services.nginx.virtualHosts = {
      "chat.${config.networking.hostName}" = {
            listen = [
              {
                addr = "0.0.0.0";
                port = 80;
              }
            ];
            locations."/" = {
              proxyPass = "http://127.0.0.1:${toString config.services.open-webui.port}";
              proxyWebsockets = true;
              recommendedProxySettings = true;
            };
          };
      "chatbot.${config.networking.hostName}" = {
        locations."/" = {          
          proxyPass = "http://127.0.0.1:${toString config.services.ollama.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
    };
  };
}
