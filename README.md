# No Blocked Popup + Offhand Gamepad fix (WoW Forever)

Two fixes for players using [Offhand](https://www.curseforge.com/wow/addons/offhand) on WoW Forever.

## 1. No Blocked Popup (addon, any OS)

Hides the *"<addon> has been blocked from an action only available to the Blizzard UI"*
popup. With Forever's **Gamepad UI** on, that popup triggers the next block, so it loops and
can freeze the game. This is a known Blizzard bug that happens with almost any addon
([forum thread](https://us.forums.blizzard.com/en/wow/t/game-crashes-native-gamepad-ui-empty-addon-triggers-blocked-action-popup-loop/2367777)).
The first hidden popup each session prints one line in chat. The rest are hidden silently.

**Install:**
1. Download **NoBlockedPopup.zip** from [Releases](../../releases/latest).
2. Unzip it into `World of Warcraft/_forever_/Interface/AddOns/`.
3. Restart WoW, or log out to the character screen.

Hiding the popup does not fix the action that was blocked. If you play with a controller and
your buttons stop working after you open the map, you also need fix 2.

## 2. Offhand Gamepad fix (controller buttons die after opening the map)

With the Gamepad UI on, Offhand removes the World Map from Blizzard's movement fader. That
taints the controller's binding state, so after you open and close the map your controller
buttons stop working until `/reload`. Details and the fix are in
[Offhand issue #84](https://github.com/N4UX-GIT/Offhand-DualMonitor/issues/84). Until the
developer ships the fix, apply it to your own installed copy.

**Mac:** run this in Terminal, then `/reload` in game:

```sh
curl -fsSL https://raw.githubusercontent.com/scottlandes1217/no-blocked-popup/main/fix-offhand-gamepad.sh | sh
```

If WoW isn't installed in `/Applications`, pass your Offhand folder:
`sh fix-offhand-gamepad.sh "/path/to/_forever_/Interface/AddOns/Offhand"`.

**Windows (manual):** open these two files in Notepad:
- `Interface\AddOns\Offhand\Core\CanvasPanelLifecycle.lua`
- `Interface\AddOns\Offhand\Core\CanvasMapPresentation.lua`

In both files, use Replace (match case) to replace `PlayerMovementFrameFader and` with
`(not (Offhand.isForever and Offhand:IsGamepadUIEnabled()) and PlayerMovementFrameFader) and`.

`CanvasPanelLifecycle.lua` also has one line that **ends** in `and PlayerMovementFrameFader`,
with no `and` after it. Change the end of that line to
`and (not (Offhand.isForever and Offhand:IsGamepadUIEnabled()) and PlayerMovementFrameFader)`.

After saving, there should be 6 changed spots in total. Then `/reload`.

Updating Offhand undoes the fix. Re-apply it afterwards, unless the update includes it.

## Is this allowed?

Both fixes are ordinary UI addon code that uses the normal addon API. They hide a dialog and
skip a cosmetic fade. They don't automate anything or read game memory. This isn't an official
Blizzard statement.

MIT licensed. Offhand is © N4UX and is not included here. The script only edits your own copy.
