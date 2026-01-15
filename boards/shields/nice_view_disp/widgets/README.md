# Commit Info Display

This directory contains code to display commit information on the nice_view display.

## How it Works

The `commit_info.h` file contains the current commit hash and message that will be displayed on the device. This file must be kept in sync with your commits.

## Automatic Updates

There are two ways to keep commit info updated automatically:

### Option 1: Pre-commit Hook (for local development)

Install the pre-commit hook to automatically update commit info when committing locally:

```bash
cp pre-commit-hook.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

Once installed, the hook automatically runs `update-commit-info.sh` and includes the updated `commit_info.h` in your commit.

**Benefits:** No extra commits in your git history

### Option 2: GitHub Actions (automatic fallback)

If you commit via web interfaces (like ZMK Studio keymap editor) or forget to run the hook, GitHub Actions will automatically:
1. Detect if `commit_info.h` is out of date
2. Update it and create a commit with message "chore: update commit info [skip ci]"
3. Build the firmware with the correct information

**Benefits:** Works for web-based commits, no manual intervention needed

### Best Practice

Install the pre-commit hook for local development. This way:
- Local commits: commit info is updated by the hook (no extra commit)
- Web commits: GitHub Actions automatically creates an update commit only when needed

## Manual Updates

You can also manually update the commit info:

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
