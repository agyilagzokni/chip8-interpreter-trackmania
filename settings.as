[Settings category="General" name="CPU Cycles/frame" drag min=0 max=50]
int Settings_CPU_cycle = 10;

[SettingsTab name="General"]
void RenderSettings(){
    Settings_CPU_cycle = UI::SliderInt("CPU Cycles/frame", Settings_CPU_cycle, 0, 200);
    isVirtualKeyboard = UI::Checkbox("Virtual keypad", isVirtualKeyboard);
}
