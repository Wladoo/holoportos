{ pkgs, ...}:

{
  name = "boot";

  machine = { ... }: {
    imports = import ../modules/module-list.nix;
  };

  testScript =
    ''
      startAll;
      $machine->waitForUnit("multi-user.target");
      $machine->shutdown;
    '';
}
