#Requires AutoHotkey v2.0

Class KompleteKontrol {
    
    Static PluginHeader := Object()
    Static StandaloneHeader := Object()
    Static PluginOverlays := Array()
    Static StandaloneOverlays := Array()
    
    Static __New() {
        ClassName := "KompleteKontrol"
        %ClassName%.NoProduct.InitClass(ClassName)
        %ClassName%.AudioImperia.InitClass(ClassName)
        %ClassName%.CinematicStudioSeries.InitClass(ClassName)
        
        PluginHeader := AccessibilityOverlay("Komplete Kontrol")
        PluginHeader.AddStaticText("Komplete Kontrol")
        PluginHeader.AddHotspotButton("Menu", 305, 68, CompensatePluginPointCoordinates, CompensatePluginPointCoordinates).SetHotkey("!M", "Alt+M")
        KompleteKontrol.PluginHeader := PluginHeader
        
        StandaloneHeader := AccessibilityOverlay("Komplete Kontrol")
        StandaloneHeader.AddHotspotButton("File menu", 24, 41).SetHotkey("!F", "Alt+F")
        StandaloneHeader.AddHotspotButton("Edit menu", 60, 41).SetHotkey("!E", "Alt+E")
        StandaloneHeader.AddHotspotButton("View menu", 91, 41).SetHotkey("!V", "Alt+V")
        StandaloneHeader.AddHotspotButton("Controller menu", 146, 41).SetHotkey("!C", "Alt+C")
        StandaloneHeader.AddHotspotButton("Help menu", 202, 41).SetHotkey("!H", "Alt+H")
        KompleteKontrol.StandaloneHeader := StandaloneHeader
        
        Plugin.Register("Komplete Kontrol", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1$", ObjBindMethod(KompleteKontrol, "InitPlugin"), True, False, False, ObjBindMethod(KompleteKontrol, "CheckPlugin"))
        
        For PluginOverlay In KompleteKontrol.PluginOverlays
        Plugin.RegisterOverlay("Komplete Kontrol", PluginOverlay)
        Plugin.RegisterOverlayHotkeys("Komplete Kontrol", PluginHeader)
        
        Plugin.SetTimer("Komplete Kontrol", ObjBindMethod(KompleteKontrol, "CheckPluginConfig"), -1)
        
        Plugin.Register("Komplete Kontrol Preference Dialog", "^NIChildWindow[0-9A-F]{17}$",, False, False, False, ObjBindMethod(KompleteKontrol, "CheckPluginPreferenceDialog"))
        Plugin.SetHotkey("Komplete Kontrol Preference Dialog", "!F4", ObjBindMethod(KompleteKontrol, "ClosePluginPreferenceDialog"))
        Plugin.SetHotkey("Komplete Kontrol Preference Dialog", "Escape", ObjBindMethod(KompleteKontrol, "ClosePluginPreferenceDialog"))
        
        PluginPreferenceOverlay := AccessibilityOverlay()
        PluginPreferenceTabControl := PluginPreferenceOverlay.AddTabControl()
        PluginPreferenceMIDITab := HotspotTab("MIDI", 56, 69)
        PluginPreferenceMIDITab.AddCustomButton("Close",, ObjBindMethod(KompleteKontrol, "ClosePluginPreferenceDialog"))
        PluginPreferenceGeneralTab := HotspotTab("General", 56, 114)
        PluginPreferenceGeneralTab.AddCustomButton("Close",, ObjBindMethod(KompleteKontrol, "ClosePluginPreferenceDialog"))
        PluginPreferenceLibraryTab := HotspotTab("Library", 56, 155)
        PluginPreferenceLibraryTabTabControl := PluginPreferenceLibraryTab.AddTabControl()
        PluginPreferenceLibraryFactoryTab := HotspotTab("Factory", 156, 76)
        PluginPreferenceLibraryFactoryTab.AddHotspotButton("Rescan", 546, 417)
        PluginPreferenceLibraryUserTab := HotspotTab("User", 240, 76)
        PluginPreferenceLibraryUserTab.AddHotspotButton("Add Directory", 170, 420)
        PluginPreferenceLibraryUserTab.AddHotspotCheckbox("Scan user content for changes at start-up", 419, 394, ["0xCCCCCC", "0xFFFFFF"], ["0x323232", "0x5F5F5F"])
        PluginPreferenceLibraryUserTab.AddHotspotButton("Rescan", 546, 417)
        PluginPreferenceLibraryTabTabControl.AddTabs(PluginPreferenceLibraryFactoryTab, PluginPreferenceLibraryUserTab)
        PluginPreferenceLibraryTab.AddCustomButton("Close",, ObjBindMethod(KompleteKontrol, "ClosePluginPreferenceDialog"))
        PluginPreferencePluginTab := HotspotTab("Plug-ins", 56, 196)
        PluginPreferencePluginTab.AddHotspotCheckbox("Always Use Latest Version Of NI Plug-ins", 419, 398, ["0xCCCCCC", "0xFFFFFF"], ["0x323232", "0x5F5F5F"])
        PluginPreferencePluginTab.AddHotspotButton("Rescan", 546, 417)
        PluginPreferencePluginTab.AddCustomButton("Close",, ObjBindMethod(KompleteKontrol, "ClosePluginPreferenceDialog"))
        PluginPreferenceTabControl.AddTabs(PluginPreferenceMIDITab, PluginPreferenceGeneralTab, PluginPreferenceLibraryTab, PluginPreferencePluginTab)
        Plugin.RegisterOverlay("Komplete Kontrol Preference Dialog", PluginPreferenceOverlay)
        
        Plugin.Register("Komplete Kontrol Save As Dialog", "^NIChildWindow[0-9A-F]{17}$",, False, False, False, ObjBindMethod(KompleteKontrol, "CheckPluginSaveAsDialog"))
        Plugin.SetHotkey("Komplete Kontrol Save As Dialog", "!F4", ObjBindMethod(KompleteKontrol, "ClosePluginSaveAsDialog"))
        Plugin.SetHotkey("Komplete Kontrol Save As Dialog", "Escape", ObjBindMethod(KompleteKontrol, "ClosePluginSaveAsDialog"))
        
        PluginSaveAsOverlay := AccessibilityOverlay()
        PluginSaveAsOverlay.AddOCREdit("Save Preset, Name:", 24, 72, 500, 88)
        PluginSaveAsOverlay.AddCustomButton("Save",, ObjBindMethod(KompleteKontrol, "SaveOrCancelPluginSaveAsDialog"))
        PluginSaveAsOverlay.AddCustomButton("Cancel",, ObjBindMethod(KompleteKontrol, "SaveOrCancelPluginSaveAsDialog"))
        Plugin.RegisterOverlay("Komplete Kontrol Save As Dialog", PluginSaveAsOverlay)
        
        Standalone.Register("Komplete Kontrol", "Komplete Kontrol ahk_class NINormalWindow* ahk_exe Komplete Kontrol.exe")
        Standalone.SetTimer("Komplete Kontrol", ObjBindMethod(KompleteKontrol, "CheckStandaloneConfig"), -1)
        Standalone.RegisterOverlay("Komplete Kontrol", StandaloneHeader)
        
        Standalone.Register("Komplete Kontrol Preference Dialog", "Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe", ObjBindMethod(KompleteKontrol, "FocusStandalonePreferenceTab"))
        Standalone.SetHotkey("Komplete Kontrol Preference Dialog", "^,", ObjBindMethod(KompleteKontrol, "ManageStandalonePreferenceDialog"))
        
        StandalonePreferenceOverlay := AccessibilityOverlay()
        StandalonePreferenceTabControl := StandalonePreferenceOverlay.AddTabControl()
        StandalonePreferenceAudioTab := HotspotTab("Audio", 56, 69)
        StandalonePreferenceAudioTab.AddCustomButton("Close",, ObjBindMethod(KompleteKontrol, "CloseStandalonePreferenceDialog"))
        StandalonePreferenceMIDITab := HotspotTab("MIDI", 56, 114)
        StandalonePreferenceMIDITab.AddCustomButton("Close",, ObjBindMethod(KompleteKontrol, "CloseStandalonePreferenceDialog"))
        StandalonePreferenceGeneralTab := HotspotTab("General", 56, 155)
        StandalonePreferenceGeneralTab.AddCustomButton("Close",, ObjBindMethod(KompleteKontrol, "CloseStandalonePreferenceDialog"))
        StandalonePreferenceLibraryTab := HotspotTab("Library", 56, 196)
        StandalonePreferenceLibraryTabTabControl := StandalonePreferenceLibraryTab.AddTabControl()
        StandalonePreferenceLibraryFactoryTab := HotspotTab("Factory", 156, 76)
        StandalonePreferenceLibraryFactoryTab.AddHotspotButton("Rescan", 546, 417)
        StandalonePreferenceLibraryUserTab := HotspotTab("User", 240, 76)
        StandalonePreferenceLibraryUserTab.AddHotspotButton("Add Directory", 170, 420)
        StandalonePreferenceLibraryUserTab.AddHotspotCheckbox("Scan user content for changes at start-up", 419, 394, ["0xCCCCCC", "0xFFFFFF"], ["0x323232", "0x5F5F5F"])
        StandalonePreferenceLibraryUserTab.AddHotspotButton("Rescan", 546, 417)
        StandalonePreferenceLibraryTabTabControl.AddTabs(StandalonePreferenceLibraryFactoryTab, StandalonePreferenceLibraryUserTab)
        StandalonePreferenceLibraryTab.AddCustomButton("Close",, ObjBindMethod(KompleteKontrol, "CloseStandalonePreferenceDialog"))
        StandalonePreferencePluginTab := HotspotTab("Plug-ins", 56, 237)
        StandalonePreferencePluginTab.AddHotspotCheckbox("Always Use Latest Version Of NI Plug-ins", 419, 398, ["0xCCCCCC", "0xFFFFFF"], ["0x323232", "0x5F5F5F"])
        StandalonePreferencePluginTab.AddHotspotButton("Rescan", 546, 417)
        StandalonePreferencePluginTab.AddCustomButton("Close",, ObjBindMethod(KompleteKontrol, "CloseStandalonePreferenceDialog"))
        StandalonePreferenceTabControl.AddTabs(StandalonePreferenceAudioTab, StandalonePreferenceMIDITab, StandalonePreferenceGeneralTab, StandalonePreferenceLibraryTab, StandalonePreferencePluginTab)
        Standalone.RegisterOverlay("Komplete Kontrol Preference Dialog", StandalonePreferenceOverlay)
        
        Standalone.Register("Komplete Kontrol Save As Dialog", "ahk_class #32770 ahk_exe Komplete Kontrol.exe",, False, False, ObjBindMethod(KompleteKontrol, "CheckStandaloneSaveAsDialog"))
        
        StandaloneSaveAsOverlay := AccessibilityOverlay()
        StandaloneSaveAsOverlay.AddOCREdit("Save Preset, Name:", 24, 72, 500, 88)
        StandaloneSaveAsOverlay.AddHotspotButton("Save", 219, 135)
        StandaloneSaveAsOverlay.AddCustomButton("Cancel",, ObjBindMethod(KompleteKontrol, "CloseStandaloneSaveAsDialog"))
        Standalone.RegisterOverlay("Komplete Kontrol Save As Dialog", StandaloneSaveAsOverlay)
    }
    
    Static CheckPlugin(*) {
        PluginInstance := Plugin.GetInstance(GetCurrentControlClass())
        If PluginInstance Is Plugin And PluginInstance.Name = "Komplete Kontrol"
        Return True
        Try
        UIAElement := GetUIAElement("15,1")
        If UIAElement != False And UIAElement.Name = "Komplete Kontrol" And UIAElement.ClassName = "ni::qt::QuickWindow"
        Return True
        Sleep 500
        Return False
    }
    
    Static CheckPluginConfig() {
        Static PluginAutoChangeFunction := ObjBindMethod(AutoChangePluginOverlay,, "Komplete Kontrol", True, True)
        If IniRead("ReaHotkey.ini", "Config", "AutomaticallyCloseLibrariBrowsersInKontaktAndKKPlugins", 1) = 1
        KompleteKontrol.ClosePluginBrowser()
        If IniRead("ReaHotkey.ini", "Config", "AutomaticallyDetectLibrariesInKontaktAndKKPlugins", 1) = 1
        Plugin.SetTimer("Komplete Kontrol", PluginAutoChangeFunction, 500)
        Else
        Plugin.SetTimer("Komplete Kontrol", PluginAutoChangeFunction, 0)
    }
    
    Static CheckPluginPreferenceDialog(PluginData) {
        If WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria) And WinGetTitle("A") = "Preferences" {
            If PluginData Is Plugin And PluginData.Name = "Komplete Kontrol Preference Dialog"
            Return True
            Else
            If PluginData Is Map And PluginData["Name"] = "Komplete Kontrol Preference Dialog"
            Return True
        }
        Return False
    }
    
    Static CheckPluginSaveAsDialog(PluginData) {
        If WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria) And ImageSearch(&FoundX, &FoundY, 130, 14, 230, 31, "Images/KontaktKompleteKontrol/SaveKKPreset.png") {
            If PluginData Is Plugin And PluginData.Name = "Komplete Kontrol Save As Dialog"
            Return True
            Else
            If PluginData Is Map And PluginData["Name"] = "Komplete Kontrol Save As Dialog"
            Return True
        }
        Return False
    }
    
    Static CheckStandaloneConfig() {
        If IniRead("ReaHotkey.ini", "Config", "AutomaticallyCloseLibrariBrowsersInKontaktAndKKStandalones", 1) = 1
        KompleteKontrol.CloseStandaloneBrowser()
    }
    
    Static CheckStandaloneSaveAsDialog(*) {
        StandaloneInstance := Standalone.GetInstance(GetCurrentWindowID())
        If StandaloneInstance Is Standalone And StandaloneInstance.Name = "Komplete Kontrol Save As Dialog"
        Return True
        If WinExist("ahk_class #32770 ahk_exe Komplete Kontrol.exe") And WinActive("ahk_class #32770 ahk_exe Komplete Kontrol.exe") And ImageSearch(&FoundX, &FoundY, 130, 14, 230, 31, "Images/KontaktKompleteKontrol/SaveKKPreset.png")
        Return True
        Return False
    }
    
    Static ClosePluginBrowser() {
        UIAElement := GetUIAElement("15,1,3")
        If UIAElement != False And RegExMatch(UIAElement.ClassName, "^LumenButton_QMLTYPE_[0-9]+$") {
            UIAElement.Click()
            AccessibilityOverlay.Speak("Library Browser closed.")
            Sleep 1000
        }
    }
    
    Static ClosePluginPreferenceDialog(*) {
        Critical
        If ReaHotkey.FoundPlugin Is Plugin And WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria)
        If ReaHotkey.FoundPlugin.Name = "Komplete Kontrol Preference Dialog" And WinGetTitle("A") = "Preferences" {
            ReaHotkey.FoundPlugin.Overlay.Reset()
            WinClose("A")
            Sleep 500
        }
    }
    
    Static ClosePluginSaveAsDialog(*) {
        Critical
        If ReaHotkey.FoundPlugin Is Plugin And WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria)
        If ReaHotkey.FoundPlugin.Name = "Komplete Kontrol Save As Dialog" And ImageSearch(&FoundX, &FoundY, 130, 14, 230, 31, "Images/KontaktKompleteKontrol/SaveKKPreset.png") {
            ReaHotkey.FoundPlugin.Overlay.Reset()
            WinClose("A")
            Sleep 500
        }
    }
    
    Static CloseStandaloneBrowser() {
        UIAElement := GetUIAElement("1,3")
        If UIAElement != False And RegExMatch(UIAElement.ClassName, "^LumenButton_QMLTYPE_[0-9]+$") {
            UIAElement.Click()
            AccessibilityOverlay.Speak("Library Browser closed.")
            Sleep 1000
        }
    }
    
    Static CloseStandalonePreferenceDialog(*) {
        WinClose("Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe")
    }
    
    Static CloseStandaloneSaveAsDialog(*) {
        WinClose("ahk_class #32770 ahk_exe Komplete Kontrol.exe")
    }
    
    Static FocusStandalonePreferenceTab(KKInstance) {
        Sleep 1000
        If KKInstance.Overlay.CurrentControlID = 0
        KKInstance.Overlay.Focus()
    }
    
    Static InitPlugin(PluginInstance) {
        If PluginInstance.Overlay.ChildControls.Length = 0
        PluginInstance.Overlay.AddAccessibilityOverlay()
        PluginInstance.Overlay.ChildControls[1] := KompleteKontrol.PluginHeader.Clone()
        If Not HasProp(PluginInstance.Overlay, "Metadata") {
            PluginInstance.Overlay.Metadata := Map("Product", "None")
            PluginInstance.Overlay.OverlayNumber := 1
        }
        Plugin.RegisterOverlayHotkeys("Komplete Kontrol", PluginInstance.Overlay)
    }
    
    Static ManageStandalonePreferenceDialog(*) {
        If WinActive("Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe") {
            WinClose("Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe")
        }
        Else If WinActive("Komplete Kontrol ahk_class NINormalWindow* ahk_exe Komplete Kontrol.exe") And Not WinExist("Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe") {
            Hotkey "^,", "Off"
            Send "^,"
        }
        Else {
            If WinExist("Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe") And Not WinActive("Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe")
            WinActivate("Preferences ahk_class #32770 ahk_exe Komplete Kontrol.exe")
        }
    }
    
    Static SaveOrCancelPluginSaveAsDialog(UiButton) {
        Critical
        If ReaHotkey.FoundPlugin Is Plugin And WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria)
        If ReaHotkey.FoundPlugin.Name = "Komplete Kontrol Save As Dialog" And ImageSearch(&FoundX, &FoundY, 130, 14, 230, 31, "Images/KontaktKompleteKontrol/SaveKKPreset.png") {
            ReaHotkey.FoundPlugin.Overlay.Reset()
            If UiButton.Label = "Save"
            Click 219, 135
            Else
            Click 301, 135
            Sleep 500
        }
    }
    
    #IncludeAgain KontaktKompleteKontrol/NoProduct.ahk
    #IncludeAgain KontaktKompleteKontrol/AudioImperia.ahk
    #IncludeAgain KontaktKompleteKontrol/CinematicStudioSeries.ahk
    
}
