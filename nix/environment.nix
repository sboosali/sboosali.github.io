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

  • HTML/CSS/JS (+ Bash/JSON): Linters.
  • JS: Package Manager, Build Tool, Project Scaffolding.
  • JS: Interpreter, Minifier, Type System.
  '';

}

##################################################