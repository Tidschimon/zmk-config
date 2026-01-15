# Commit Info Display

This directory contains code to display commit information on the nice_view display.

## How it Works

The `commit_info.h` file contains the current commit hash and message that will be displayed on the device. This file is committed to the repository.

## Automatic Updates (GitHub Actions)

When you push to the repository, GitHub Actions will automatically:
1. Run the `update-commit-info.sh` script to generate the latest commit info
2. Commit and push the updated `commit_info.h` if it changed
3. Build the firmware with the updated commit information

The commit message includes `[skip ci]` to prevent triggering another build cycle.

## Manual Updates (Optional)

You can also manually update the commit info before committing:

```bash
./update-commit-info.sh
git add boards/shields/nice_view_disp/widgets/commit_info.h
git commit -m "your commit message"
```

### Manual Edit

If needed, you can manually edit `boards/shields/nice_view_disp/widgets/commit_info.h`:

```c
#define GIT_COMMIT_HASH "abc1234"       // 7-character commit hash
#define GIT_COMMIT_MSG_LINE1 "Your m"   // First 7 characters of commit message
#define GIT_COMMIT_MSG_LINE2 "essage"   // Next 7 characters of commit message
```

## Why Not Generate at Build Time?

During the ZMK GitHub Actions build process, the zmk-config repository is processed as a Zephyr module. At CMake configuration time, the git repository is not accessible, making it impossible to run `git log` commands to retrieve commit information dynamically. Therefore, the commit info must be committed to the repository beforehand.
