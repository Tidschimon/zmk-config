# Commit Info Display

This directory contains code to display commit information on the nice_view display.

## How it Works

The `commit_info.h` file contains the current commit hash and message that will be displayed on the device. This file is committed to the repository and should be updated before pushing changes.

## Updating Commit Info

### Automatic (Recommended)

Run the update script before committing:

```bash
./update-commit-info.sh
git add boards/shields/nice_view_disp/widgets/commit_info.h
git commit -m "your commit message"
```

### Manual

Edit `boards/shields/nice_view_disp/widgets/commit_info.h` and update the values:

```c
#define GIT_COMMIT_HASH "abc1234"       // 7-character commit hash
#define GIT_COMMIT_MSG_LINE1 "Your m"   // First 7 characters of commit message
#define GIT_COMMIT_MSG_LINE2 "essage"   // Next 7 characters of commit message
```

## Why Not Generate at Build Time?

During the ZMK GitHub Actions build process, the zmk-config repository is processed as a Zephyr module. At CMake configuration time, the git repository is not accessible, making it impossible to run `git log` commands to retrieve commit information dynamically. Therefore, the commit info must be committed to the repository beforehand.
