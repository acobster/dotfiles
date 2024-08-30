## PARTITIONS

On my main driver I want the following partitions:

- Boot
    - EFI
    - 200M
- Swap
    - Linux Swap
    - 2G
    - LUKS-encrypted
- NixOS
    - EXT4? Btrfs?
    - 100GB+
    - LUKS-encrypted
- Home
    - Btrfs
    - Remaining HD space
    - LUKS-encrypted

Look into [Disko](https://github.com/nix-community/disko?tab=readme-ov-file) to [provision](https://github.com/nix-community/disko?tab=readme-ov-file#sample-configuration-and-cli-command) this for us

## Fun FIFO / Named Pipes hack

The `bin/consume` script in this repo is my favorite Bash script I've ever written.

I originally learned the concept of FIFOs, AKA named pipes, from an episode of Gary Bernhardt's Destroy All Software screencast. In that episode, Gary describes a general Unix test runner that accepts arbitrary commands and prints their output, listening in an infinite loop and running each command as it comes in.

He starts with a humble offering, which you can run directly on the command line:

```
mkfifo test-commands
cat test-commands
```

What the `mkfifo` command does is create a file called `test-commands` of type named pipe, a special Unix file type. The `cat` command will block until it reads something from the pipe.

So when will that happen? When we write to it (from, say, a separate terminal window):

```sh
echo 'hello pipe' > test-commands
```

The `cat` process will now spit out `hello pipe` and exit normally. `echo` implicity writes an EOF to `test-commands`, so `cat` finished reading and terminates like it would on any other file.

This works because `test-commands`, like any ol' Unix pipe, has a "read end" and a "write end". The special thing about names pipes is that they get a concrete filesystem path, just like a normal file. This lets us write to it from anywhere else on the system, like we just did.

https://github.com/acobster/dotfiles/commit/9fdab8961771809bace27ff671dc49df069b6487
https://github.com/acobster/dotfiles/commit/c11edb0d3fd19ae6da8eadf7d0820cdd6a4f1e44

## MISC

- [Horrible screen flickering on Dell XPS](https://www.dell.com/community/en/conversations/linux-general/xps-13-7390-ubuntu-screen-flickering/647f8528f4ccf8a8de410276)
