{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
    mpv
  ];

  # https://devenv.sh/languages/
  languages = {
    lua.enable = true;
  };

  # https://devenv.sh/processes/
  # processes.dev.exec = "${lib.getExe pkgs.watchexec} -n -- ls -la";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  # https://devenv.sh/basics/
  enterShell = ''
    hello         # Run scripts directly
    git --version # Use packages
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  scripts.mpv-test.exec = /* sh */ ''
    echo "''${@}"
    mpv --script=${config.git.root}/mpv-timestamp-close.lua "''${@}"
  '';

  # https://devenv.sh/git-hooks/
  git-hooks.hooks = {
    stylua.enable = true;
    nixfmt = {
      enable = true;
      package = pkgs.nixfmt-rs;
    };
  };

  # See full reference at https://devenv.sh/reference/options/
}
