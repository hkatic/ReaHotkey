#Requires AutoHotkey v2.0

#MaxThreadsPerHotkey 1
#SingleInstance Force
#Warn LocalSameAsGlobal, Off
SendMode "Input"
SetTitleMatchMode "RegEx"
SetWorkingDir A_InitialWorkingDir
CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"

#Include Includes/Overlay.Functions.ahk

#Include <AccessibilityOverlay>
#Include <OCR>
#Include <Plugin>
#Include <ReaHotkey>
#Include <Standalone>

A_IconTip := "ReaHotkey"
A_TrayMenu.Delete
A_TrayMenu.Add("&Pause", ReaHotkey.TogglePause)
A_TrayMenu.Add("&Close", ReaHotkey.Close)

AccessibilityOverlay.Speak("ReaHotkey ready")

Plugin.Register("Engine", "^Plugin[0-9A-F]{17}")
Plugin.Register("Kontakt/Komplete Kontrol", ["^NIVSTChildWindow00007.*", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1"],, True)
Standalone.Register("Engine", "Best Service Engine ahk_class Engine ahk_exe Engine 2.exe")

ReaHotkey.ImportOverlays()

#Include Includes/Plugin.Context.ahk
#Include Includes/Standalone.Context.ahk

SetTimer ReaHotkey.UpdateState, 100
SetTimer ReaHotkey.ManageTimers, 100
SetTimer ReaHotkey.ManageInput, 100
