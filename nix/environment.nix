##################################################
{ stdenv
, systemPackages
, nodePackages
}:

##################################################
# Imports ########################################
##################################################
let
#------------------------------------------------#

programs = import ./programs.nix
  { inherit systemPackages nodePackages;
  };

#------------------------------------------------#
in
##################################################

stdenv.mkDerivation {

  name = "sboosali.github.io_environment";

  # The packages in the `buildInputs` list will be added to the PATH in our shell

  buildInputs = programs;

  description = ''
  Programs for web development:

  • HTML/CSS/JS (and Bash): Linters.
  • JS: Package Manager, Build Tool.
  • JS: Interpreter, Minifier.
  '';

}

##################################################