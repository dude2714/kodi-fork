# Kodi Fork Standalone (Windows)

This fork is pinned to Kodi 21.3 on branch `omega-21.3`.

Goal: run your fork without touching your existing Kodi install/profile.

## 1. Build your fork

Follow the Windows build guide in `docs/README.Windows.md`.

Typical output executable path:
- `%USERPROFILE%\\kodi-build\\Release\\kodi.exe`

## 2. Use portable mode (no profile interference)

Run Kodi with `-p` from the built executable location.

Example:

```bat
"%USERPROFILE%\\kodi-build\\Release\\kodi.exe" -p
```

Portable mode keeps data in a local `portable_data` folder next to that `kodi.exe`.
That isolates this fork from `%APPDATA%\\Kodi` used by your regular install.

## 3. Optional launcher shortcut

Create a desktop shortcut target like:

```bat
"%USERPROFILE%\\kodi-build\\Release\\kodi.exe" -p
```

Name it something distinct, e.g. `Kodi Fork 21.3 Portable`.

## 4. Update behavior

A local built portable fork does not auto-replace your normal Kodi install.
You control updates by rebuilding or switching branches/tags in this repository.

## 5. Current git remotes

- `origin`: `https://github.com/dude2714/kodi-fork.git`
- `upstream`: `https://github.com/xbmc/xbmc.git`
