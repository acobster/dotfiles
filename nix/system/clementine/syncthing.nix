{ pkgs, ... }:

{
  services = {
    # https://wiki.nixos.org/wiki/Syncthing
    syncthing = {
      enable = true;
      group = "users";
      user = "tamayo";
      dataDir = "/home/tamayo/Sync";
      settings = {
        gui = {
          user = "tamayo";
          password = "pourover";
        };
        devices = {
          # This is the machine nastyboi originally synced to.
          #"clementine" = { id = "UFNJALL-L75PPG7-63AYQOY-IGDVDE3-ZTRP3KV-RQIARGB-5K7OI2K-G5DZKQB"; };
          "nastyboi" = { id = "ANZ3S3B-L4H5BZU-OAXMIFJ-FN2RX66-5ZF3VOO-MAE6VEI-LDM4ED6-NBY2OQQ"; };
        };
        relaysEnabled = false;
        setLowPriority = false;
        copiers = 16;
        hashers = 16;
        databaseTuning = "large";
        maxConcurrentIncomingRequestKiB = 2048;
        folders = {
          "archive" = {
            id = "zgpfk-jzghx";
            path = "/home/tamayo/Sync/archive";
            devices = [ "nastyboi" ];
          };
          "articles" = {
            id = "zhtfw-hwjw9";
            path = "/home/tamayo/Sync/articles";
            devices = [ "nastyboi" ];
          };
          "data.h" = {
            id = "pzezg-wwcqz";
            path = "/home/tamayo/Sync/data.h";
            devices = [ "nastyboi" ];
          };
          "docs" = {
            id = "docs";
            path = "/home/tamayo/Sync/docs";
            devices = [ "nastyboi" ];
          };
          "ledger" = {
            id = "ledger";
            path = "/home/tamayo/ledger";
            devices = [ "nastyboi" ];
          };
          "movies" = {
            id = "7rkpv-epj4e";
            path = "/home/tamayo/Sync/movies";
            devices = [ "nastyboi" ];
          };
          "music" = {
            id = "oevph-m7uaw";
            path = "/home/tamayo/Sync/music";
            devices = [ "nastyboi" ];
          };
          "pictures" = {
            id = "jgjvt-mjfkq";
            path = "/home/tamayo/Sync/pictures";
            devices = [ "nastyboi" ];
          };
          "projects" = {
            id = "projects";
            path = "/home/tamayo/projects";
            devices = [ "nastyboi" ];
          };
          "recordings" = {
            id = "qwn2t-4bahx";
            path = "/home/tamayo/Sync/recordings";
            devices = [ "nastyboi" ];
          };
          "shows" = {
            id = "dfhyg-qcobu";
            path = "/home/tamayo/Sync/shows";
            devices = [ "nastyboi" ];
          };
          "videos" = {
            id = "qdfcq-5dwbp";
            path = "/home/tamayo/Sync/videos";
            devices = [ "nastyboi" ];
          };
        };
      };
    };
  };
}
