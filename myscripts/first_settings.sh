#!/bin/bash

# ctrl + rでコマンド履歴を遡る際に
# ctrl + sで履歴を進める機能を有効にする
stty stop undef

# homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# neobundle install
curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh

# nodebrew
sudo brew install nodebrew
# nodejs
sudo nodebrew install-binary stable
sudo nodebrew use stable
sudo nodebrew install latest

# install lua
brew install lua

# vim update
brew update
brew reinstall vim --with-lua
# (+lua)になってればok
# vim --version | grep lua

# install rmtrash
brew install rmtrash

# Karabiner
# vim normalモード抜けたら自動で半角
# 自分で設定していたら書き換わるので注意(初期設定前提)
addKarabinerSetting() {
cat << EOS > $HOME/Library/Application\ Support/Karabiner/private.xml
<?xml version="1.0"?>
<root>
  <list>
    <item>
      <name>Local Hacks</name>
      <list>
        <item>
          <name>KANA Key</name>
          <list>
            <item>
              <name>KANA to KANA/EISUU (toggle)</name>
              <appendix>(Except VMware Fusion, Parallels Desktop, Remote Desktop Connection)</appendix>
              <identifier>remap.kana_to_kana_eisuu_toggle</identifier>
              <not>VIRTUALMACHINE, REMOTEDESKTOPCONNECTION</not>
              <autogen>--KeyToKey-- KeyCode::JIS_KANA, KeyCode::VK_JIS_TOGGLE_EISUU_KANA</autogen>
            </item>
          </list>
        </item>
        <item>
          <name>EISUU Key</name>
          <list>
            <item>
              <name>EISUU to Option+ESC</name>
              <appendix>(Except VMware Fusion, Parallels Desktop, Remote Desktop Connection)</appendix>
              <identifier>remap.eisuu_to_option_esc</identifier>
              <not>VIRTUALMACHINE, REMOTEDESKTOPCONNECTION</not>
              <autogen>--KeyToKey-- KeyCode::JIS_EISUU, KeyCode::ESCAPE, ModifierFlag::OPTION_L</autogen>
            </item>
          </list>
        </item>
      </list>
    </item>
    <item>
      <name>LeaveInsMode with EISUU(Terminal)</name>
      <only>TERMINAL</only>
      <identifier>private.app_terminal_esc_with_eisuu</identifier>
      <autogen>--KeyToKey-- KeyCode::BRACKET_RIGHT, VK_CONTROL, KeyCode::BRACKET_RIGHT, VK_CONTROL, KeyCode::JIS_EISUU</autogen>
   </item>
		<item>
			<name>ESC to IME off (to English) + Esc + Esc</name>
			<appendix>Enable for all but HHK</appendix>
			<identifier>private.vim.ime_off_ESC</identifier>
			<only>TERMINAL, VI</only>
			<inputsource_only>JAPANESE</inputsource_only>
			<autogen>
				__KeyToKey__ KeyCode::ESCAPE, ModifierFlag::NONE,
				KeyCode::VK_CHANGE_INPUTSOURCE_ENGLISH,
				KeyCode::VK_CHANGE_INPUTSOURCE_JAPANESE,
				KeyCode::VK_CHANGE_INPUTSOURCE_ENGLISH,
				KeyCode::ESCAPE, KeyCode::ESCAPE
			</autogen>
		</item>
		<item>
			<name>Control + BRACKET_LEFT to IME off (to English) + Esc + Esc</name>
			<identifier>private.vim.ime_new</identifier>
			<only>TERMINAL, VI</only>
			<inputsource_only>JAPANESE</inputsource_only>
			<autogen>
				__KeyToKey__ KeyCode::BRACKET_LEFT,
				MODIFIERFLAG_EITHER_LEFT_OR_RIGHT_CONTROL|ModifierFlag::NONE,
				KeyCode::VK_CHANGE_INPUTSOURCE_ENGLISH,
				KeyCode::VK_CHANGE_INPUTSOURCE_JAPANESE,
				KeyCode::VK_CHANGE_INPUTSOURCE_ENGLISH,
				KeyCode::ESCAPE, KeyCode::ESCAPE
			</autogen>
		</item>
  </list>
</root>
EOS
}

read -p "Overwrite Karabiner's private.xml. Are you alright? (y/n) " RESP
if [ "$RESP" = "y" ]; then
	addKarabinerSetting
else
  echo "cancel overwrite"
fi
