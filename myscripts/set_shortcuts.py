#!/usr/bin/env python3
import os
import plistlib
import subprocess

plist_path = os.path.expanduser('~/Library/Preferences/com.apple.symbolichotkeys.plist')

with open(plist_path, 'rb') as f:
    data = plistlib.load(f)

hotkeys = data.setdefault('AppleSymbolicHotKeys', {})

def set_hotkey(hotkey_id, enabled, params=None):
    entry = {'enabled': bool(enabled)}
    if params is not None:
        entry['value'] = {
            'parameters': [int(p) for p in params],
            'type': 'standard'
        }
    hotkeys[str(hotkey_id)] = entry

# 27: 次のウインドウを操作対象にする -> Option + Tab (65535, 48, 524288)
set_hotkey(27, True, [65535, 48, 524288])

# 32: Mission Control -> Control + : (58, 39, 262144)
set_hotkey(32, True, [58, 39, 262144])

# 60: 前の入力ソースを選択 -> 無効 (Disabled)
set_hotkey(60, False, [32, 49, 262144])

# 61: 入力メニューの次のソースを選択 -> F13 (65535, 105, 8388608)
set_hotkey(61, True, [65535, 105, 8388608])

# 79, 80: 左の操作スペースに移動 -> Control + L (108, 37, 393216)
set_hotkey(79, True, [108, 37, 393216])
set_hotkey(80, True, [108, 37, 393216])

# 81, 82: 右に操作スペースに移動 -> Control + ; (59, 41, 393216)
set_hotkey(81, True, [59, 41, 393216])
set_hotkey(82, True, [59, 41, 393216])

with open(plist_path, 'wb') as f:
    plistlib.dump(data, f)

# cfprefsd に同期 & ホットキーデーモン・Dock の再読み込み
subprocess.run(['defaults', 'read', 'com.apple.symbolichotkeys'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
subprocess.run(['/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings', '-u'], stderr=subprocess.DEVNULL)
subprocess.run(['killall', 'Dock'], stderr=subprocess.DEVNULL)

print("Keyboard shortcuts configured successfully.")
