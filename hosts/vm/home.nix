{
  config,
  dotfiles,
  sops-nix,
  ...
}:

{
  imports = [
    sops-nix.homeManagerModules.sops
    ../../modules/home.nix
    ../../modules/pkgs.nix
    ../common.nix
  ];

  sops = {
    gnupg = {
      home = "${config.programs.gpg.homedir}";
    };
    secrets = {
      # NOTE: Make sure the secret "key" matches the name, otherwise, you need
      # to specify the key name under "key" field.
      openai_api_key = {
        sopsFile = "${dotfiles}/secrets/api.json";
        format = "json";
      };
      anthropic_api_key = {
        sopsFile = "${dotfiles}/secrets/api.json";
        format = "json";
      };
    };
  };

  home.sessionVariables = {
    OPENAI_API_KEY = "$(cat ${config.sops.secrets.openai_api_key.path})";
    ANTHROPIC_API_KEY = "$(cat ${config.sops.secrets.anthropic_api_key.path})";
  };
}
