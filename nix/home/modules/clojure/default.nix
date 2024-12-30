{ pkgs, ... }:

{
  home.packages = with pkgs; [
    babashka
    clojure
    jdk21
    joker
  ];

  home.file.".clojure/deps.edn".source = ./deps.edn;
}
