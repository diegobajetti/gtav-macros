#NoEnv
SetWorkingDir %A_ScriptDir%
#IfWinActive ahk_class grcWindow
#SingleInstance, force
if not A_IsAdmin
  Run *RunAs "%A_ScriptFullPath%"

BST := "["
Armor := "]"
Snack := "\"
Outfit := "F9"
CallSimeon := "F12"
IncInventoryLocation := "'"
DecInventoryLocation := ";"
NoSaveModeOn := ">^f9"
NoSaveModeOff := ">^f12"
InternetKillSwitchOn := ">^f5"
InternetKillSwitchOff := ">^f6"

global InvLocation := 3

global ToolTip1 := false
global ToolTip2 := false
global ToolTip3 := false

Interaction := "XButton2"

global IntMenuDelay := 0.1
global KeySendDelay := 0.1
global KeyPressDuration := 4
global PhoneMenuDelay := 500
global PhoneScrollDelay := 45

Hotkey, %BST%, BST
Hotkey, %Armor%, Armor
Hotkey, %Snack%, Snack
Hotkey, %Outfit%, Outfit
Hotkey, %CallSimeon%, CallSimeon
Hotkey, %IncInventoryLocation%, IncInventoryLocation
Hotkey, %DecInventoryLocation%, DecInventoryLocation
Hotkey, %NoSaveModeOn%, NoSaveModeOn
Hotkey, %NoSaveModeOff%, NoSaveModeOff
Hotkey, %InternetKillSwitchOn%, InternetKillSwitchOn
Hotkey, %InternetKillSwitchOff%, InternetKillSwitchOff

F1::suspend
  return
  setkeydelay, KeySendDelay, KeyPressDuration

BST:
  Send {%Interaction%}
  sleep, IntMenuDelay
  Send {enter}{up 3}{enter}{down}{enter}
  return

Armor:
  Send {%Interaction%}
  sleep, IntMenuDelay
  Send {down %InvLocation%}{enter}{down 4}{enter}{up 3}
  return

Snack:
  Send {%Interaction%}
  sleep, IntMenuDelay
  Send {down %InvLocation%}{enter}{down 5}{enter 4}{%Interaction%}
  return

Outfit:
  StyleLocation := InvLocation + 1
  Send {%Interaction%}
  sleep, IntMenuDelay
  Send {down %StyleLocation%}{enter}{down 3}
  return

CallSimeon:
  ; dialNumber(6115550120)
  Send {MButton}
  sleep, PhoneMenuDelay
  setkeydelay PhoneScrollDelay, KeyPressDuration
  Send {up}{right}{enter}{up}{enter}
  return

IncInventoryLocation:
  InvLocation++

  ToolTip1 := true
  n := getActiveToolTips()
  yPos := n * 25 + 10

  ToolTip, INVENTORY=%InvLocation%, 10, %yPos%, 1
  SetTimer, RemoveToolTip1, -3000
  return

DecInventoryLocation:
  InvLocation--
  if (InvLocation < 1)
    InvLocation := 1

  Tooltip1 := true
  n := getActiveToolTips()
  yPos := n * 25 + 10

  Tooltip, INVENTORY=%InvLocation%, 10, %yPos%, 1
  SetTimer, RemoveToolTip1, -3000
  return

NoSaveModeOn:
  RunWait netsh advfirewall firewall add rule name="123456" dir=out action=block remoteip="192.81.241.171" ,,hide

  ToolTip2 := true
  n := getActiveToolTips()
  yPos := n * 25 + 10

  Tooltip, NO SAVING MODE ON, 10, %yPos%, 2
  return

NoSaveModeOff:
  RunWait netsh advfirewall firewall delete rule name="123456" ,,hide

  n := getActiveToolTips()
  ToolTip2 := false
  yPos := n * 25 + 10

  ToolTip, NO SAVING MODE OFF, 10, %yPos%, 2
  SetTimer, RemoveToolTip2, -3000
  return

InternetKillSwitchOn:
  networkInterfaceToggle(false)

  ToolTip3 := true
  n := getActiveToolTips()
  yPos := n * 25 + 10

  Tooltip, INTERNET KILL SWITCH ON, 10, %yPos%, 3
  return

InternetKillSwitchOff:
  networkInterfaceToggle()

  n := getActiveToolTips()
  ToolTip3 := false
  yPos := n * 25 + 10

  ToolTip, INTERNET KILL SWITCH OFF, 10, %yPos%, 3
  SetTimer, RemoveToolTip3, -3000
  return

networkInterfaceToggle(enable=true) {
  interfaces := ["Wi-Fi", "Ethernet", "Ethernet 3", "vEthernet (Default Switch)", "vEthernet (WSL)"]
  for each, interface in interfaces
  {
    run, *runas %comspec% /c netsh interface set interface name=%interface% admin=enable ? enabled : disabled,,hide
  }
}

dialNumber(n) {
  Send {MButton}
  sleep, PhoneMenuDelay
  setkeydelay PhoneScrollDelay, KeyPressDuration
  Send {up}{right}{enter}{space}
  pointer := 1
  Loop, parse, n
  {
    deltax := _phonePointerCol(A_LoopField) - _phonePointerCol(pointer)
    deltay := _phonePointerRow(A_LoopField) - _phonePointerRow(pointer)

    if (deltax = 2)
      deltax := -1
    if (deltax = -2)
      deltax := 1
    if (deltay = -3)
      deltay := 1
    if (deltay = 3)
      deltay := -1

    if (deltax > 0)
      Send {right %deltax%}
    if (deltay > 0)
      Send {down %deltay%}
    if (deltax < 0) {
      deltax := Abs(deltax)
      Send {left %deltax%}
    }
    if (deltay < 0) {
      deltay := Abs(deltay)
      Send {up %deltay%}
    }

    pointer := A_LoopField
    Send {enter}
  }
  Send {space}
}

_phonePointerRow(n) {
  if (n = 0)
    return 4
  else
    return Ceil(n / 3)
}

_phonePointerCol(n) {
  if (n = 0)
    return 2
  else
    div := Mod(n, 3)
    return div = 0 ? 3 : div
}

getActiveToolTips() {
  ToolTipCounter := -1
  if (ToolTip1)
    ToolTipCounter++
  if (ToolTip2)
    ToolTipCounter++
  if (ToolTip3)
    ToolTipCounter++
  return ToolTipCounter
}

RemoveToolTip1:
  Tooltip,,,,1
  ToolTip1 := false
  return

RemoveToolTip2:
  Tooltip,,,,2
  return

RemoveToolTip3:
  Tooltip,,,,3
  return
