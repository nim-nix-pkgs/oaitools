{
  description = ''High Level OAI-PMH library for Nim'';

  inputs.flakeNimbleLib.owner = "riinr";
  inputs.flakeNimbleLib.ref   = "master";
  inputs.flakeNimbleLib.repo  = "nim-flakes-lib";
  inputs.flakeNimbleLib.type  = "github";
  inputs.flakeNimbleLib.inputs.nixpkgs.follows = "nixpkgs";
  
  inputs.src-oaitools-master.flake = false;
  inputs.src-oaitools-master.ref   = "refs/heads/master";
  inputs.src-oaitools-master.owner = "markpbaggett";
  inputs.src-oaitools-master.repo  = "oaitools.nim";
  inputs.src-oaitools-master.type  = "github";
  
  inputs."xmltools".owner = "nim-nix-pkgs";
  inputs."xmltools".ref   = "master";
  inputs."xmltools".repo  = "xmltools";
  inputs."xmltools".dir   = "v0_1_5";
  inputs."xmltools".type  = "github";
  inputs."xmltools".inputs.nixpkgs.follows = "nixpkgs";
  inputs."xmltools".inputs.flakeNimbleLib.follows = "flakeNimbleLib";
  
  outputs = { self, nixpkgs, flakeNimbleLib, ...}@deps:
  let 
    lib  = flakeNimbleLib.lib;
    args = ["self" "nixpkgs" "flakeNimbleLib" "src-oaitools-master"];
    over = if builtins.pathExists ./override.nix 
           then { override = import ./override.nix; }
           else { };
  in lib.mkRefOutput (over // {
    inherit self nixpkgs ;
    src  = deps."src-oaitools-master";
    deps = builtins.removeAttrs deps args;
    meta = builtins.fromJSON (builtins.readFile ./meta.json);
  } );
}