##################################################
{ systemPackages
, nodePackages
}:

##################################################
let
#------------------------------------------------#

systemPrograms = with systemPackages; [

  nodejs                        # JS Interpreter
# npm                           # JS Package Manager

  html-tidy                     # HTML Linter
  csslint                       # CSS Linter
  shellcheck                    # Bash Linter

];

#------------------------------------------------#

nodePrograms = with nodePackages; [

  webpack                       # JS Build Tool
  eslint                        # JS Linter
  uglify-js                     # JS Minifier

];

#------------------------------------------------#
in
##################################################

nodePrograms ++ systemPrograms

##################################################
## Notes #########################################
##################################################

# html-tidy
# stylelint(?) TODO
# eslint
# shellcheck

##################################################