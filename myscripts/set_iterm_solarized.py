#!/usr/bin/env python3
"""
iTerm2のカラープロファイルを altercation/solarized に設定するスクリプト
https://github.com/altercation/solarized
"""

import argparse
import os
import plistlib
import subprocess
import sys
import urllib.request

RAW_BASE_URL = "https://raw.githubusercontent.com/altercation/solarized/master/iterm2-colors-solarized"
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_DIR = os.path.dirname(SCRIPT_DIR)
GIT_MISC_DIR = os.path.join(REPO_DIR, "git-misc")

SCHEMES = {
    'light': "Solarized Light",
    'dark': "Solarized Dark",
}


def load_itermcolors(theme_name):
    """ローカルの git-misc または GitHub (altercation/solarized) から .itermcolors を取得"""
    local_path = os.path.join(GIT_MISC_DIR, f"{theme_name}.itermcolors")
    if os.path.exists(local_path):
        with open(local_path, "rb") as f:
            return plistlib.load(f)

    # フォールバック: GitHubから直接取得
    url = f"{RAW_BASE_URL}/{urllib.parse.quote(theme_name)}.itermcolors"
    try:
        with urllib.request.urlopen(url) as res:
            return plistlib.loads(res.read())
    except Exception as e:
        print(f"Error fetching {url}: {e}", file=sys.stderr)
        sys.exit(1)


def is_iterm_running():
    res = subprocess.run(['pgrep', '-x', 'iTerm2'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    if res.returncode == 0:
        return True
    res = subprocess.run(['pgrep', '-x', 'iTerm'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return res.returncode == 0


def main():
    parser = argparse.ArgumentParser(description='Set iTerm2 color theme using altercation/solarized.')
    parser.add_argument('--theme', choices=['light', 'dark'], default='light',
                        help='Theme to apply to the default profile (default: light)')
    parser.add_argument('--preset-only', action='store_true',
                        help='Only add presets without modifying profiles')
    args = parser.parse_args()

    selected_theme_name = SCHEMES[args.theme]

    if is_iterm_running():
        print("Warning: iTerm2 is currently running.")
        print("Settings will be saved, but please restart iTerm2 to ensure all changes take effect.")

    # Load schemes from altercation/solarized
    light_colors = load_itermcolors(SCHEMES['light'])
    dark_colors = load_itermcolors(SCHEMES['dark'])
    selected_colors = light_colors if args.theme == 'light' else dark_colors

    plist_path = os.path.expanduser('~/Library/Preferences/com.googlecode.iterm2.plist')

    data = {}
    if os.path.exists(plist_path):
        try:
            with open(plist_path, 'rb') as f:
                data = plistlib.load(f)
        except Exception as e:
            print(f"Error loading {plist_path}: {e}", file=sys.stderr)
            sys.exit(1)

    # 1. Custom Color Presets に登録
    presets = data.setdefault('Custom Color Presets', {})
    presets[SCHEMES['light']] = light_colors
    presets[SCHEMES['dark']] = dark_colors

    # 2. プロファイルにテーマを適用
    if not args.preset_only:
        bookmarks = data.setdefault('New Bookmarks', [])
        if not bookmarks:
            default_profile = {
                'Name': 'Default',
                'Guid': 'Default',
                'Default Bookmark': 'Yes',
            }
            bookmarks.append(default_profile)

        target_profiles = [b for b in bookmarks if b.get('Name') == 'Default']
        if not target_profiles:
            target_profiles = bookmarks

        for profile in target_profiles:
            # OSの外観モード差分で色が崩れないよう無効化
            profile['Use Separate Colors for Light and Dark Mode'] = False

            for key, val in selected_colors.items():
                profile[key] = val
                profile[f"{key} (Light)"] = val
                profile[f"{key} (Dark)"] = val

    # 3. plist 保存
    os.makedirs(os.path.dirname(plist_path), exist_ok=True)
    with open(plist_path, 'wb') as f:
        plistlib.dump(data, f)

    # 4. cfprefsd に同期
    subprocess.run(['defaults', 'read', 'com.googlecode.iterm2'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

    action = "Presets registered" if args.preset_only else f"Applied {selected_theme_name} and registered presets"
    print(f"iTerm2 color configuration updated successfully! ({action})")


if __name__ == '__main__':
    main()
