{ pkgs, ... }:

{
  home.packages = with pkgs; [
    babashka
    clojure
    jdk21
    joker
  ];
}
