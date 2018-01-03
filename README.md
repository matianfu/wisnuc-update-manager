How to use this branch.

```
# clone the full repo
git clone https://github.com/wisnuc/wisnuc-bootstrap

# change directory
cd wisnuc-bootstrap

# checkout release branch
git checkout release

# run script
./release.sh
```

The output looks like:
```
root@iZj6cbpg2ix521j0cz4jkaZ:~/wisnuc-bootstrap# ./release.sh
after this operation other branchs are corrupted
e981fece34a0dd9f7322291a8dbd53c90c0eebd84972d3c6c1181a5a4f074bab
e981fece34a0dd9f7322291a8dbd53c90c0eebd84972d3c6c1181a5a4f074bab
Initialized empty Git repository in /root/wisnuc-bootstrap/.git/
[master (root-commit) 3b3a552] reinit
 5 files changed, 714 insertions(+)
 create mode 100644 LICENSE
 create mode 100644 README.md
 create mode 100755 release.sh
 create mode 100755 wisnuc-bootstrap-linux-x64
 create mode 100644 wisnuc-bootstrap-linux-x64-sha256
Switched to a new branch 'release'
Username for 'https://github.com':
```

Notice there are two lines of sha256 hash value, they should be equal.
