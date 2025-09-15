{ ... }:

{
  # Thanks Xe! https://xeiaso.net/blog/borg-backup-2021-01-09/
  # NOTE: to get this to work the first time, verify the key with:
  #   ssh -i ~/.ssh/borgbase_ed25519 b667xtzf.repo.borgbase.com
  services.borgbackup.jobs."borgbase-sync" = {
    paths = [ "/home/tamayo/Sync" ];
    exclude = [
      "Sync/.config"
    ];
    repo = "ssh://b667xtzf@b667xtzf.repo.borgbase.com/./repo";
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat /home/tamayo/.borgbackup/passphrase";
    };
    environment = {
      BORG_RSH = "ssh -i /home/tamayo/.ssh/borgbase_ed25519 -o UserKnownHostsFile=/home/tamayo/.ssh/known_hosts";
    };
    compression = "auto,zstd";
    startAt = "daily";
  };
}
