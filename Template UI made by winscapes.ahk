;----------------- made by @winscapes -------------------------------;
;------------------skid dis------------------------------------------;

#SingleInstance, Force
#Persistent
#InstallKeybdHook
#UseHook
SetKeyDelay, -1, -1
SetControlDelay, -1
SetMouseDelay, -1
SetWinDelay, -1
SendMode, InputThenPlay
SetBatchLines, -1
CoordMode, Pixel, Screen
#Include JSON.ahk

Sleep, 400

jsonPath := "config.json"
FileRead, jsonText, %jsonPath%
settings := JSON.Load(jsonText)
initialSlider := settings.Settings.Slider
SwitchToggle := settings.Settings.Switch
Field := settings.Settings.Field
Dropdown := settings.Settings.Dropdown

if (settings.Settings.Switch = 1)  
   {
       SwitchPic := "assets/switchon.png" 
   } 
   else 
   {
       SwitchPic := "assets/switchoff.png" 
   }

; === Slider Setup ===
trackImage := "assets/sliderbg.png"
fillImage := "assets/sliderfill.png"

sliderX := 180
sliderY := 150
trackWidth := 170
trackHeight := 20
isDragging := false
prec := "%"

value := initialSlider
fillWidth := Round((value / 100.0) * trackWidth)
if (fillWidth < 8)
    fillWidth := 8

; === GUI Config ===
Width := 400
Height := 500
CornerRadius := 12
gui_control_options := " -E0x200"

Gui, +LastFound +AlwaysOnTop -Caption +ToolWindow
WinSet, Transparent, 255
Gui, Color, 0A0A0A, 141414
Gui, Margin, 10, 10

Gui, Add, Progress, % "x-1 y-1 w" (Width+2) " h50 Background0A0A0A Disabled hwndHPROG"
Control, ExStyle, -0x20000, , ahk_id %HPROG%
Gui, Font, s11 c232323
Gui, Add, Text, % "x0 y-2 w" Width " h50 BackgroundTrans Center 0x200 gGuiMove vCaption",


; === Rounded Corners ===
hRgn := DllCall("CreateRoundRectRgn", "int", 0, "int", 0, "int", Width + 1, "int", Height + 1, "int", CornerRadius, "int", CornerRadius, "ptr")
DllCall("SetWindowRgn", "ptr", WinExist(), "ptr", hRgn, "int", true)
DllCall("DeleteObject", "ptr", hRgn)

; === Title ===
Gui, Font, s14 cFFFFFF, Konkhmer Sleokchher
Gui, Add, Text, x180 y50 w150 h40 BackgroundTrans  0x200 vTitle, Template Gui
Gui, Add, Text, x180 y50 w150 h40 BackgroundTrans  0x200 vTitle2, @winscapes :)... 

Gui, Font, s9 cFFFFFF, Konkhmer Sleokchher
Gui, Add, Text, x306 y100 w50 h40 BackgroundTrans  0x200 vValueDisp, %value% [%prec%]


; === Static GUI Images ===
Gui, Font, s12 cFFFFFF, Konkhmer Sleokchher

Gui, Add, Picture, x150 y50 w3 h400 BackgroundTrans vLine, assets/line.png
Gui, Add, Picture, x38 y90 w75 h75 BackgroundTrans vTab1 gPageflip2, assets/tab1.png
Gui, Add, Picture, x56 y165 w39 h3 BackgroundTrans vSelected1, assets/selected.png
Gui, Add, Picture, x56 y275 w39 h3 BackgroundTrans vSelected2, assets/selected.png
Gui, Add, Picture, x38 y200 w75 h75 BackgroundTrans vTab2 gPageflip, assets/tab2.png
Gui, Add, Text, x180 y100 w50 h40 BackgroundTrans  0x200 vCaption1, Slider
Gui, Add, Picture, x180 y90 w70 h1 BackgroundTrans vLine2_1, assets/line2.png
Gui, Add, Text, x180 y210 w56 h40 BackgroundTrans  0x200 vCaption2, Switch
Gui, Add, Picture, x180 y200 w70 h1 BackgroundTrans vLine2_2, assets/line2.png
Gui, Add, Text, x180 y271 w56 h40 BackgroundTrans  0x200 vCaption3, Field
Gui, Add, Picture, x180 y260 w70 h1 BackgroundTrans vLine2_3, assets/line2.png
Gui, Add, Picture, x180 y321 w70 h1 BackgroundTrans vLine2_4, assets/line2.png
Gui, Add, Picture, x%sliderX% y%sliderY% w%trackWidth% h%trackHeight% BackgroundTrans vSlider1, %trackImage%
Gui, Add, Picture, x%sliderX% y%sliderY% w%fillWidth% h%trackHeight% BackgroundTrans vSliderFill gMaybeStartDrag, %fillImage%
Gui, Add, Picture, x310 y220 w40 h20 BackgroundTrans vSwitchPicControl gToggleSwitch, %SwitchPic%
Gui, Add, Picture, x270 y281 w80 h20 BackgroundTrans vEntry, assets/entry.png
Gui, Add, Picture, x270 y342 w58 h20 BackgroundTrans vDropdown1, assets/dropdown1.png
Gui, Add, Picture, x270 y342 w58 h60 BackgroundTrans vDropdown2, assets/dropdown2.png
Gui, Add, Text, x180 y332 w56 h40 BackgroundTrans  0x200 vCaption4, Drop



Gui, Font, s7 cFFFFFF, Konkhmer Sleokchher
Gui, Add, Edit, %gui_control_options% x275 y283 w70 h15 -VScroll gUpdateField vField, %Field%
Gui, Add, Text, x278 y333 w50 h40 BackgroundTrans  0x200 vDropdowntext1, %Dropdown%
Gui, Add, Picture, x330 y342 w20 h20 BackgroundTrans vDropButton1 gDrop, assets/dropbutton.png
Gui, Add, Picture, x330 y342 w20 h20 BackgroundTrans vDropButton2 gFold, assets/dropbutton2.png
Gui, Add, Text, x278 y366 w50 h10 BackgroundTrans  0x200 vDropdowntext2 gselTorso, Torso
Gui, Add, Text, x278 y385 w50 h10 BackgroundTrans  0x200 vDropdowntext3 gselHead, Head
Gui, Add, Text, x278 y333 w50 h40 BackgroundTrans  0x200 vDropdowntext4, Head
Gui, Add, Text, x278 y333 w50 h40 BackgroundTrans  0x200 vDropdowntext5, Torso

GuiControl, Hide, Title2
GuiControl, Hide, Selected2
GuiControl, Hide, Dropdown2
GuiControl, Hide, DropButton2
GuiControl, Hide, Dropdowntext2
GuiControl, Hide, Dropdowntext3
GuiControl, Hide, Dropdowntext4
GuiControl, Hide, Dropdowntext5
Gui, Show, w%Width% h%Height%, ZyuL V2
Return

; === Drag from fill edge only ===
MaybeStartDrag:
    CoordMode, Mouse, Screen
    MouseGetPos, mx, my
    WinGetPos, gx, gy,,, A
    relX := mx - gx

    fillRightEdge := sliderX + fillWidth
    if (relX >= fillRightEdge - 8 && relX <= fillRightEdge + 8) {
        isDragging := true
        SetTimer, DragSlider, 10
    }
return

DragSlider:
    If !GetKeyState("LButton", "P") {
        SetTimer, DragSlider, Off
        isDragging := false

        settings.Settings.Slider := Round(value)
        FileDelete, %jsonPath%
        FileAppend, % JSON.Dump(settings, 4), %jsonPath%
        return
    }

    CoordMode, Mouse, Screen
    MouseGetPos, mx, my
    WinGetPos, gx, gy,,, A
    relX := mx - gx

    minX := sliderX
    maxX := sliderX + trackWidth
    posX := relX
    if (posX < minX)
        posX := minX
    if (posX > maxX)
        posX := maxX

    fillWidth := posX - sliderX
    if (fillWidth < 8)
      fillWidth := 8

    GuiControl, Move, SliderFill, w%fillWidth%

    value := Round((fillWidth / trackWidth) * 100)
    GuiControl,, ValueDisp, %value% [%prec%]
return

ToggleSwitch:

if (SwitchPic := (SwitchPic = "assets/SwitchOFF.png" ? "assets/SwitchON.png" : "assets/SwitchOFF.png"))
{
    GuiControl,, SwitchPicControl, %SwitchPic% 

  
    settings.Settings.Switch := (settings.Settings.Switch = 1) ? 0 : 1 
    
    
    SaveJson(jsonPath, settings)
}
Return

UpdateField:
    Gui, Submit, NoHide 
    settings.Settings.Field := Field  
    
    
    SaveJson(jsonPath, settings)
Return

Drop:
   GuiControl, Hide, Dropdown1
   GuiControl, Show, Dropdown2
   GuiControl, Hide, DropButton1
   GuiControl, Show, DropButton2
   GuiControl, Show, Dropdowntext2
   GuiControl, Show, Dropdowntext3
Return

Fold:
   GuiControl, Show, Dropdown1
   GuiControl, Hide, Dropdown2
   GuiControl, Show, DropButton1
   GuiControl, Hide, DropButton2
   GuiControl, Hide, Dropdowntext2
   GuiControl, Hide, Dropdowntext3
Return

selHead:
   GuiControl, Hide, Dropdowntext5
   GuiControl, Hide, Dropdowntext1
   GuiControl, Show, Dropdowntext4
   GuiControl, Show, Dropdown1
   GuiControl, Hide, Dropdown2
   GuiControl, Show, DropButton1
   GuiControl, Hide, DropButton2
   GuiControl, Hide, Dropdowntext2
   GuiControl, Hide, Dropdowntext3

   settings.Settings.Dropdown := "Head"
   SaveJson(jsonPath, settings)
Return

selTorso:
   GuiControl, Show, Dropdowntext5
   GuiControl, Hide, Dropdowntext1
   GuiControl, Hide, Dropdowntext4
   GuiControl, Show, Dropdown1
   GuiControl, Hide, Dropdown2
   GuiControl, Show, DropButton1
   GuiControl, Hide, DropButton2
   GuiControl, Hide, Dropdowntext2
   GuiControl, Hide, Dropdowntext3

   settings.Settings.Dropdown := "Torso"
   SaveJson(jsonPath, settings)
Return

Pageflip:
   GuiControl, Hide, Selected1
   GuiControl, Show, Selected2
   GuiControl, Hide, Caption1
   GuiControl, Hide, Line2_1
   GuiControl, Hide, Caption2
   GuiControl, Hide, Line2_2
   GuiControl, Hide, Caption3
   GuiControl, Hide, Line2_3
   GuiControl, Hide, Line2_4
   GuiControl, Hide, Slider1
   GuiControl, Hide, SliderFill
   GuiControl, Hide, SwitchPicControl
   GuiControl, Hide, Entry
   GuiControl, Hide, Dropdown1
   GuiControl, Hide, Dropdown2
   GuiControl, Hide, Caption4
   GuiControl, Hide, Field
   GuiControl, Hide, Dropdowntext1
   GuiControl, Hide, DropButton1
   GuiControl, Hide, DropButton2
   GuiControl, Hide, Dropdowntext2
   GuiControl, Hide, Dropdowntext3
   GuiControl, Hide, Dropdowntext4
   GuiControl, Hide, Dropdowntext5
   GuiControl, Hide, Title
   GuiControl, Hide, ValueDisp
   GuiControl, Show, Title2
Return

Pageflip2:
    settings := ReloadSettings(jsonPath)
    
    Dropdown := settings.Settings.Dropdown

    GuiControl, Show, Selected1
    GuiControl, Hide, Selected2
    GuiControl, Show, Caption1
    GuiControl, Show, Line2_1
    GuiControl, Show, Caption2
    GuiControl, Show, Line2_2
    GuiControl, Show, Caption3
    GuiControl, Show, Line2_3
    GuiControl, Show, Line2_4
    GuiControl, Show, Slider1
    GuiControl, Show, SliderFill
    GuiControl, Show, SwitchPicControl
    GuiControl, Show, Entry
    GuiControl, Show, Dropdown1
    GuiControl, Show, Caption4
    GuiControl, Show, Field
    GuiControl, Show, Dropdowntext1
    GuiControl, Show, DropButton1
    GuiControl, Show, DropButton2
    GuiControl, Show, Title
    GuiControl, Show, ValueDisp
    GuiControl, Hide, Title2

    GuiControl,, Dropdowntext1, %Dropdown%
return

ReloadSettings(jsonPath) {
   FileRead, jsonText, %jsonPath%
   settings := JSON.Load(jsonText)
   return settings
}

GuiMove:
    PostMessage, 0xA1, 2,,, A
return


SaveJson(path, obj) {
   FileDelete, %path%
   FileAppend, % JSON.Dump(obj, 4), %path%
}

GuiClose:
ExitApp:
    ExitApp
return
