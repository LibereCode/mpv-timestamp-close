{ inputs, ... }:
{
  systems = [
    "x86_64-linux"
    #NOTE: need testing for other systems
  ];

  imports = [
    ./packages
  ];
}
