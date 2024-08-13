#Requires AutoHotkey v2.0

Class NoProduct {
    
    Static PluginClass := ""
    
    __New() {
        ClassNames := StrSplit(This.__Class, ".")
        PluginClass := ClassNames[1]
        VendorClass := ClassNames[2]
        %PluginClass%.%VendorClass%.PluginClass := PluginClass
    }
    
    Static __New() {
        This()
        PluginClass := This.PluginClass
        
        NoProductOverlay := AccessibilityOverlay("None")
        NoProductOverlay.Metadata := Map("Product", "None")
        NoProductOverlay.AddAccessibilityOverlay()
        %PluginClass%.PluginOverlays.Push(NoProductOverlay)
    }
    
}
