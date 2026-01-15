# Commit Info Display

This directory contains code to display commit information on the nice_view display.

## How it Works

The `commit_info.h` file contains the current commit hash and message that will be displayed on the device. This file must be updated and committed before pushing changes.

## Setup (One-time)

Install the pre-commit hook to automatically update commit info:

```bash
cp pre-commit-hook.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

Once installed, the hook will automatically run `update-commit-info.sh` and include the updated `commit_info.h` in your commit.

## Manual Updates

If you prefer not to use the pre-commit hook, run the script before committing:

```bash
./update-commit-info.sh
git add boards/shields/nice_view_disp/widgets/commit_info.h
git commit -m "your commit message"
```

## How the Script Works

The `update-commit-info.sh` script:
1. Gets the current commit hash (7 characters)
2. Gets the commit message and truncates it to 14 characters
3. Splits the message into two 7-character lines for the display
4. Updates `commit_info.h` with this information

## Manual Edit (Not Recommended)

You can manually edit `boards/shields/nice_view_disp/widgets/commit_info.h`:

```c
#define GIT_COMMIT_HASH "abc1234"       // 7-character commit hash
#define GIT_COMMIT_MSG_LINE1 "Your m"   // First 7 characters of commit message
#define GIT_COMMIT_MSG_LINE2 "essage"   // Next 7 characters of commit message
```

## Why Not Generate at Build Time?

During the ZMK GitHub Actions build process, the zmk-config repository is processed as a Zephyr module. At CMake configuration time, the git repository is not accessible, making it impossible to run `git log` commands to retrieve commit information dynamically. Therefore, the commit info must be committed to the repository beforehand.
