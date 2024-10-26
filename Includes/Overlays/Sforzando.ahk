﻿#Requires AutoHotkey v2.0

Class Sforzando {
    
    Static __New() {
        Plugin.Register("sforzando", "^Plugin[0-9A-F]{17}$", ObjBindMethod(Sforzando, "InitPlugin"), False, False, False, ObjBindMethod(Sforzando, "CheckPlugin"))
        Standalone.Register("sforzando", "Plogue Art et Technologie, Inc sforzando ahk_class PLGWindowClass ahk_exe sforzando( x64)?.exe", ObjBindMethod(Sforzando, "InitStandalone"), False, False)
    }
    
    Static CheckPlugin(*) {
        Thread "NoTimers"
        PluginInstance := Plugin.GetInstance(GetCurrentControlClass())
        If PluginInstance Is Plugin And PluginInstance.Name = "sforzando"
        Return True
        UIAElement := GetUIAElement("15,1")
        Try
        If not UIAElement = False And UIAElement.Name = "PlogueXMLGUI"
        Return True
        Return False
    }
    
    Static InitPlugin(PluginInstance) {
        PluginHeader := AccessibilityOverlay()
        PluginHeader.AddControl(Sforzando.OCRButton("Instrument", "(value not detected)", 100, 76, 340, 87,,, CompensatePluginCoordinates,, CompensatePluginCoordinates))
        PluginHeader.AddControl(Sforzando.OCRButton("Polyphony", "(value not detected)", 480, 90, 540, 120,,, CompensatePluginCoordinates,, CompensatePluginCoordinates))
        PluginHeader.AddControl(Sforzando.OCRButton("Pitchbend range", "(value not detected)", 580, 90, 610, 110,,, CompensatePluginCoordinates,, CompensatePluginCoordinates))
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
    
    Class OCRButton Extends OCRButton {
        
        DefaultLabel := ""
        DefaultOCRString := ""
        
        __New(Label, DefaultOCRString, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := 1, PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "") {
            Super.__New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage, OCRScale, PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions)
            This.Label := Label
            This.DefaultOCRString := DefaultOCRString
        }
        
        SpeakOnActivation(Speak := True) {
            Message := ""
            CheckResult := This.GetState()
            LabelString := This.Label
            If LabelString = ""
            LabelString := This.DefaultLabel
            OCRString := AccessibilityOverlay.OCR(This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, This.OCRLanguage, This.OCRScale)
            If OCRString = ""
            OCRString := This.DefaultOCRString
            StateString := ""
            If This.States.Has(CheckResult)
            StateString := This.States[CheckResult]
            If not This.ControlID = AccessibilityOverlay.PreviousControlID
            Message := LabelString . " " . OCRString . " " . This.ControlTypeLabel . " " . StateString
            Else
            If This.States.Count > 1
            Message := StateString
            If Speak
            AccessibilityOverlay.Speak(Message)
        }
        
        SpeakOnFocus(Speak := True) {
            Message := ""
            CheckResult := This.GetState()
            LabelString := This.Label
            If LabelString = ""
            LabelString := This.DefaultLabel
            OCRString := AccessibilityOverlay.OCR(This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, This.OCRLanguage, This.OCRScale)
            If OCRString = ""
            OCRString := This.DefaultOCRString
            StateString := ""
            If This.States.Has(CheckResult)
            StateString := This.States[CheckResult]
            If not This.ControlID = AccessibilityOverlay.PreviousControlID Or (This.GetMasterControl() Is AccessibilityOverlay And This.GetMasterControl().GetFocusableControlIDs().Length = 1)
            Message := LabelString . " " . OCRString . " " . This.ControlTypeLabel . " " . StateString . " " . This.HotkeyLabel
            If Speak
            AccessibilityOverlay.Speak(Message)
        }
        
    }
    
}
