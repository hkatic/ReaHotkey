#Requires AutoHotkey v2.0

Class Plugin {
    
    Chooser := True
    ControlClass := ""
    FocusFunction := ""
    Name := ""
    Overlay := AccessibilityOverlay()
    Overlays := Array()
    SingleInstance := False
    Static ChooserOverlay := AccessibilityOverlay()
    Static DefaultOverlay := AccessibilityOverlay()
    Static Instances := Array()
    Static List := Array()
    Static UnnamedPluginName := "Unnamed Plugin"
    
    __New(Name, ControlClass, FocusFunction := "", SingleInstance := False, Chooser := True) {
        If Name == ""
        This.Name := Plugin.UnnamedPluginName
        Else
        This.Name := Name
        This.ControlClass := ControlClass
        This.FocusFunction := FocusFunction
        If SingleInstance == True Or SingleInstance == False
        This.SingleInstance := SingleInstance
        Else
        This.SingleInstance := False
        If Chooser == True Or Chooser == False
        This.Chooser := Chooser
        Else
        This.Chooser := True
        For Overlay In Plugin.GetOverlays(Name)
        This.Overlays.Push(Overlay.Clone())
        If This.Overlays.Length == 1 {
            This.Overlay := This.Overlays[1].Clone()
        }
        Else If This.Overlays.Length > 1 And This.Chooser == False {
            This.Overlay := This.Overlays[1].Clone()
        }
        Else If This.Overlays.Length > 1 And This.Chooser == True {
            This.Overlay := AccessibilityOverlay()
            This.Overlay.AddControl(Plugin.ChooserOverlay.Clone())
        }
        Else {
            This.Overlay := AccessibilityOverlay()
            This.Overlay.AddControl(Plugin.DefaultOverlay.Clone())
        }
    }
    
    Focus() {
        If This.FocusFunction != ""
        %This.FocusFunction.Name%(This)
    }
    
    GetHotkeys() {
        Return Plugin.GetHotkeys(This.Name)
    }
    
    GetOverlay() {
        Return This.Overlay
    }
    
    GetOverlays() {
        Return This.Overlays
    }
    
    Static FindClass(ClassName) {
        For PluginNumber, PluginEntry In Plugin.List {
            If PluginEntry["ControlClasses"] Is Array And PluginEntry["ControlClasses"].Length > 0
            For ControlClass In PluginEntry["ControlClasses"]
            If RegExMatch(ClassName, ControlClass)
            Return PluginNumber
        }
        Return 0
    }
    
    Static FindHotkey(PluginName, KeyName) {
        PluginNumber := Plugin.FindName(PluginName)
        If PluginNumber > 0
        For HotkeyNumber, HotkeyParams In Plugin.List[PluginNumber]["Hotkeys"]
        If HotkeyParams["KeyName"] == KeyName
        Return HotkeyNumber
        Return 0
    }
    
    Static FindName(PluginName) {
        For PluginNumber, PluginEntry In Plugin.List
        If PluginEntry["Name"] == PluginName
        Return PluginNumber
        Return 0
    }
    
    Static FindTimer(PluginName, Function) {
        PluginNumber := Plugin.FindName(PluginName)
        If PluginNumber > 0
        For TimerNumber, TimerParams In Plugin.List[PluginNumber]["Timers"]
        If TimerParams["Function"] == Function
        Return TimerNumber
        Return 0
    }
    
    Static GetByClass(ControlClass) {
        PluginNumber := Plugin.FindClass(ControlClass)
        If PluginNumber > 0 {
            PluginName := Plugin.List[PluginNumber]["Name"]
            SingleInstance := Plugin.List[PluginNumber]["SingleInstance"]
            Chooser := Plugin.List[PluginNumber]["Chooser"]
            If SingleInstance == True {
                For PluginInstance In Plugin.Instances
                If PluginInstance.Name == PluginName
                Return PluginInstance
            }
            Else {
                SingleInstance := False
                For PluginInstance In Plugin.Instances
                If PluginInstance.ControlClass == ControlClass
                Return PluginInstance
            }
            PluginInstance := Plugin(Plugin.List[PluginNumber]["Name"], ControlClass, Plugin.List[PluginNumber]["FocusFunction"], SingleInstance, Chooser)
            Plugin.Instances.Push(PluginInstance)
            Return PluginInstance
        }
        Return Plugin("", ControlClass)
    }
    
    Static GetHotkeys(PluginName) {
        PluginNumber := Plugin.FindName(PluginName)
        If PluginNumber > 0
        Return Plugin.List[PluginNumber]["Hotkeys"]
        Return Array()
    }
    
    Static GetList() {
        Return Plugin.List
    }
    
    Static GetOverlays(PluginName) {
        PluginNumber := Plugin.FindName(PluginName)
        If PluginNumber > 0
        Return Plugin.List[PluginNumber]["Overlays"]
        Return Array()
    }
    
    Static GetTimers(PluginName) {
        PluginNumber := Plugin.FindName(PluginName)
        If PluginNumber > 0
        Return Plugin.List[PluginNumber]["Timers"]
        Return Array()
    }
    
    Static SetHotkey(PluginName, KeyName, Action := "", Options := "") {
        PluginNumber := Plugin.FindName(PluginName)
        HotkeyNumber := Plugin.FindHotkey(PluginName, KeyName)
        If PluginNumber > 0 And HotkeyNumber == 0 {
            BackupAction := Action
            OnOff := ""
            B := ""
            P := ""
            S := ""
            T := ""
            I := ""
            HotkeyOptions := StrSplit(Options, [A_Space, A_Tab])
            If Not HotkeyOptions Is Array
            HotkeyOptions := Array(Options)
            Match := ""
            For Option In HotkeyOptions {
                If RegexMatch(Option, "i)^((On)|(Off))$", &Match)
                OnOff := Match[0]
                If RegexMatch(Option, "i)^(B0?)$", &Match)
                B := Match[0]
                If RegexMatch(Option, "i)^((P[1-9][0-9]*)|(P0?))$", &Match)
                P := Match[0]
                If RegexMatch(Option, "i)^(S0?)$", &Match)
                S := Match[0]
                If RegexMatch(Option, "i)^(T([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]))$", &Match)
                T := Match[0]
                If RegexMatch(Option, "i)^(I([0-9]|[1-9][0-9]|100))$", &Match)
                I := Match[0]
            }
            Options := Trim(OnOff . " " . B . " " . P . " " . S . " " . T . " " . I)
            If OnOff = "Off"
            Action := "Off"
            Plugin.List[PluginNumber]["Hotkeys"].Push(Map("KeyName", KeyName, "Action", Action, "Options", Options, "BackupAction", BackupAction))
        }
        Else {
            If HotkeyNumber > 0 {
                If Action == ""
                Action := Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Action"]
                If Options == ""
                Options := Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Options"]
                If Action != Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Action"] {
                    If Action Is Object {
                        If Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Action"] != "Off" {
                            Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["BackupAction"] := Action
                        }
                        Else {
                            Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["BackupAction"] := Action
                            Action := "Off"
                        }
                    }
                    Else {
                        If Trim(Action) = "Toggle" {
                            If Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Action"] = "Off"
                            Action := "On"
                            Else
                            Action := "Off"
                        }
                        If Trim(Action) = "On"
                        Action := Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["BackupAction"]
                        If Not Action Is Object And Trim(Action) = "Off"
                        If Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Action"] != "On" And Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Action"] != "Off"
                        Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["BackupAction"] := Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Action"]
                        If                Not Action Is Object {
                            Action := Trim(Action)
                            If Action != "On" And Action != "Off"
                            Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["BackupAction"] := Action
                        }
                    }
                }
                If Options != Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Options"] {
                    OnOff := ""
                    B := ""
                    P := ""
                    S := ""
                    T := ""
                    I := ""
                    CurrentOptions := StrSplit(Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Options"], [A_Space, A_Tab])
                    NewOptions := StrSplit(Options, [A_Space, A_Tab])
                    If Not CurrentOptions Is Array
                    CurrentOptions := Array(Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Options"])
                    If Not NewOptions Is Array
                    NewOptions := Array(Options)
                    Match := ""
                    For Option In CurrentOptions {
                        If RegexMatch(Option, "i)^((On)|(Off))$", &Match)
                        OnOff := Match[0]
                        If RegexMatch(Option, "i)^(B0?)$", &Match)
                        B := Match[0]
                        If RegexMatch(Option, "i)^((P[1-9][0-9]*)|(P0?))$", &Match)
                        P := Match[0]
                        If RegexMatch(Option, "i)^(S0?)$", &Match)
                        S := Match[0]
                        If RegexMatch(Option, "i)^(T([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]))$", &Match)
                        T := Match[0]
                        If RegexMatch(Option, "i)^(I([0-9]|[1-9][0-9]|100))$", &Match)
                        I := Match[0]
                    }
                    For Option In NewOptions {
                        If RegexMatch(Option, "i)^((On)|(Off))$", &Match)
                        OnOff := Match[0]
                        If RegexMatch(Option, "i)^(B0?)$", &Match)
                        B := Match[0]
                        If RegexMatch(Option, "i)^((P[1-9][0-9]*)|(P0?))$", &Match)
                        P := Match[0]
                        If RegexMatch(Option, "i)^(S0?)$", &Match)
                        S := Match[0]
                        If RegexMatch(Option, "i)^(T([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]))$", &Match)
                        T := Match[0]
                        If RegexMatch(Option, "i)^(I([0-9]|[1-9][0-9]|100))$", &Match)
                        I := Match[0]
                    }
                    Options := Trim(OnOff . " " . B . " " . P . " " . S . " " . T . " " . I)
                    If OnOff = "On"
                    Action := Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["BackupAction"]
                    If OnOff = "Off" {
                        Action := "Off"
                        If Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Action"] != "On" And Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Action"] != "Off"
                        Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["BackupAction"] := Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Action"]
                    }
                }
                Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Action"] := Action
                Plugin.List[PluginNumber]["Hotkeys"][HotkeyNumber]["Options"] := Options
            }
        }
    }
    
    Static SetTimer(PluginName, Function, Period := "", Priority := "") {
        PluginNumber := Plugin.FindName(PluginName)
        TimerNumber := Plugin.FindTimer(PluginName, Function)
        If PluginNumber > 0 And TimerNumber == 0 {
            If Period == ""
            Period := 250
            If Priority == ""
            Priority := 0
            Plugin.List[PluginNumber]["Timers"].Push(Map("Function", Function, "Period", Period, "Priority", Priority, "Enabled", False))
        }
        Else {
            If TimerNumber > 0 {
                If Period == ""
                Period := Plugin.List[PluginNumber]["Timers"][TimerNumber]["Period"]
                If Priority == ""
                Priority := Plugin.List[PluginNumber]["Timers"][TimerNumber]["Priority"]
                Plugin.List[PluginNumber]["Timers"][TimerNumber]["Period"] := Period
                Plugin.List[PluginNumber]["Timers"][TimerNumber]["Priority"] := Priority
            }
        }
    }
    
    Static Register(PluginName, ControlClasses, FocusFunction := "", SingleInstance := False, Chooser := True) {
        If Plugin.FindName(PluginName) == False {
            If PluginName == ""
            PluginName := Plugin.UnnamedPluginName
            If SingleInstance != True And SingleInstance != False
            SingleInstance := False
            If Chooser != True And Chooser != False
            Chooser := False
            PluginEntry := Map()
            PluginEntry["Name"] := PluginName
            If ControlClasses Is Array
            PluginEntry["ControlClasses"] := ControlClasses
            Else
            PluginEntry["ControlClasses"] := Array(ControlClasses)
            PluginEntry["FocusFunction"] := FocusFunction
            PluginEntry["SingleInstance"] := SingleInstance
            PluginEntry["Chooser"] := Chooser
            PluginEntry["Hotkeys"] := Array()
            PluginEntry["Overlays"] := Array()
            PluginEntry["Timers"] := Array()
            Plugin.List.Push(PluginEntry)
        }
    }
    
    Static RegisterOverlay(PluginName, PluginOverlay) {
        PluginNumber := Plugin.FindName(PluginName)
        If PluginNumber > 0
        Plugin.List[PluginNumber]["Overlays"].Push(PluginOverlay.Clone())
    }
    
}
