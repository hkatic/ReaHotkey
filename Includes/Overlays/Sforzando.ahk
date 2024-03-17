﻿#Requires AutoHotkey v2.0

Class Sforzando {
    
    Static __New() {
        Plugin.Register("sforzando", "^Plugin[0-9A-F]{17}$", ObjBindMethod(Sforzando, "InitPlugin"), True)
        Standalone.Register("sforzando", "Plogue Art et Technologie, Inc sforzando ahk_class PLGWindowClass ahk_exe sforzando( x64)?.exe", ObjBindMethod(Sforzando, "InitStandalone"))
    }
    
    Static InitPlugin(PluginInstance) {
        PluginHeader := AccessibilityOverlay()
        PluginHeader.AddControl(Sforzando.OCRButton("Instrument", "(value not detected)", 100, 76, 340, 87,,, CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates))
        PluginHeader.AddControl(Sforzando.OCRButton("Polyphony", "(value not detected)", 480, 90, 540, 120,,, CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates))
        PluginHeader.AddControl(Sforzando.OCRButton("Pitchbend range", "(value not detected)", 580, 90, 610, 110,,, CompensatePluginRegionCoordinates, CompensatePluginRegionCoordinates))
        PluginInstance.Overlay.Label := "sforzando"
        If PluginInstance.Overlay.ChildControls.Length = 0
        PluginInstance.Overlay.AddAccessibilityOverlay()
        PluginInstance.Overlay.ChildControls[1] := PluginHeader
    }
    
    Static InitStandalone(StandaloneInstance) {
        StandaloneHeader := AccessibilityOverlay()
        StandaloneHeader.AddControl(Sforzando.OCRButton("Instrument", "(value not detected)", 100, 76, 340, 87))
        StandaloneHeader.AddControl(Sforzando.OCRButton("Polyphony", "(value not detected)", 480, 90, 540, 120))
        StandaloneHeader.AddControl(Sforzando.OCRButton("Pitchbend range", "(value not detected)", 580, 90, 610, 110))
        StandaloneInstance.Overlay.Label := "sforzando"
        If StandaloneInstance.Overlay.ChildControls.Length = 0
        StandaloneInstance.Overlay.AddAccessibilityOverlay()
        StandaloneInstance.Overlay.ChildControls[1] := StandaloneHeader
    }
    
    Class OCRButton Extends ActivatableOCR {
        
        ControlType := "Button"
        ControlTypeLabel := "button"
        DefaultLabelOCR := ""
        HotkeyLabel := ""
        LabelOCR := ""
        LabelStatic := ""
        UnlabelledString := ""
        
        __New(LabelStatic, DefaultLabelOCR, RegionX1Coordinate, RegionY1Coordinate, RegionX2Coordinate, RegionY2Coordinate, OCRLanguage := "", OCRScale := 1, OnFocusFunction := "", OnActivateFunction := "") {
            Super.__New(RegionX1Coordinate, RegionY1Coordinate, RegionX2Coordinate, RegionY2Coordinate, OCRLanguage, OCRScale, OnFocusFunction, OnActivateFunction)
            This.DefaultLabelOCR := DefaultLabelOCR
            This.LabelStatic := LabelStatic
        }
        
        Activate(CurrentControlID := 0) {
            Super.Activate(CurrentControlID)
            This.LabelOCR := AccessibilityOverlay.OCR(This.RegionX1Coordinate, This.RegionY1Coordinate, This.RegionX2Coordinate, This.RegionY2Coordinate, This.OCRLanguage, This.OCRScale)
            If This.LabelOCR = ""
            This.LabelOCR := This.DefaultLabelOCR
            If This.ControlID != CurrentControlID {
                If This.LabelStatic = "" And This.LabelOCR = ""
                AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
                Else
                AccessibilityOverlay.Speak(This.LabelStatic . " " . This.LabelOCR . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
            }
        }
        
        Focus(CurrentControlID := 0) {
            Super.Focus(CurrentControlID)
            This.LabelOCR := AccessibilityOverlay.OCR(This.RegionX1Coordinate, This.RegionY1Coordinate, This.RegionX2Coordinate, This.RegionY2Coordinate, This.OCRLanguage, This.OCRScale)
            If This.LabelOCR = ""
            This.LabelOCR := This.DefaultLabelOCR
            If This.ControlID != CurrentControlID {
                If This.LabelStatic = "" And This.LabelOCR := ""
                AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
                Else
                AccessibilityOverlay.Speak(This.LabelStatic . " " . This.LabelOCR . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
            }
        }
        
        SetHotkey(HotkeyCommand, HotkeyLabel := "", HotkeyFunction := "") {
            Super.SetHotkey(HotkeyCommand, HotkeyFunction)
            This.HotkeyLabel := HotkeyLabel
        }
        
    }
    
}
