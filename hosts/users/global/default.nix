{ config, ... }:
let
	mkUser = import ../make;
in
	mkUser { name = "aaron"; sudo = true; }
