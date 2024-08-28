{ pkgs, ... }:

{
  home.file.".githelpers".source = ../../../git/helpers.bash;

  programs.git = {
    enable = true;
    userName = "Coby Tamayo";
    userEmail = "coby@tamayo.email";
    aliases = {
      st = "status";
      churn = "!git-churn";
      sh = "stash";
      pop = "stash pop";
      local = "!git l $(git current-remote-branch)..HEAD";
      aa = "add --all";
      d = "diff";
      dc = "diff --cached";
      dw = "diff -w";
      files = "diff --name-only";
      ha = "add --all --patch";
      co = "checkout";
      ci = "commit";
      m = "commit -m";
      cam = "commit -am";
      gam = "!git commit --amend -m \"$(git log -1 --pretty=%s)\"";
      amend = "commit --amend";
      root = "rev-parse --show-toplevel";
      last = "diff HEAD~1 HEAD";
      last-log = "log -1 HEAD";
      cache = "diff --name-only --cached";
      rs = "reset";
      cl = "clean -fd";
      current-branch = "rev-parse --abbrev-ref HEAD";
      cb = "rev-parse --abbrev-ref HEAD";
      current-remote-branch = "!echo origin/$(git current-branch)";
      cr = "!echo origin/$(git current-branch)";
      b = "branch";
      ff = "merge --ff-only";
      where = "branch --contains";
      head = "!git r -1";
      h = "!git head";
      hp = "!. ~/.githelpers && show_git_head";
      r = "!GIT_NO_PAGER=1 git l -30";
      ra = "!git r --all";
      ls = "log --pretty=\"%s\"";
      l = "!. ~/.githelpers && pretty_git_log";
      o = "log --oneline";
      la = "!git-links";
      continue = "rebase --continue";
      d1 = "diff HEAD~2 HEAD~1";
      d2 = "diff HEAD~3 HEAD~2";
      d3 = "diff HEAD~3 HEAD~2";
      d4 = "diff HEAD~5 HEAD~4";
      d5 = "diff HEAD~6 HEAD~5";
      l1 = "!. ~/.githelpers && pretty_git_log -1";
      l2 = "!. ~/.githelpers && pretty_git_log -2";
      l3 = "!. ~/.githelpers && pretty_git_log -3";
      l4 = "!. ~/.githelpers && pretty_git_log -4";
      l5 = "!. ~/.githelpers && pretty_git_log -5";
      l6 = "!. ~/.githelpers && pretty_git_log -6";
      l7 = "!. ~/.githelpers && pretty_git_log -7";
      l8 = "!. ~/.githelpers && pretty_git_log -8";
      l9 = "!. ~/.githelpers && pretty_git_log -9";
      l10 = "!. ~/.githelpers && pretty_git_log -10";
      sperm = "!git diff -p -R --no-ext-diff --no-color | grep -E '^(diff|(old|new) mode)' --color=never | git apply";
    };
  };
}
