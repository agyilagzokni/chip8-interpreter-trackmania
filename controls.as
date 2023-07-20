auto inputs = cast<CInputScriptPad@>(app.InputPort.Script_Pads[1]);

array<uint8> keypad(16, 0x00);

/* NATIVE KEYS AS STORED IN MEMORY
+---+---+---+---+
| 1 | 2 | 3 | C |
+---+---+---+---+
| 4 | 5 | 6 | D |
+---+---+---+---+
| 7 | 8 | 9 | E |
+---+---+---+---+
| A | 0 | B | F |
+---+---+---+---+

/* SHOWED IN GAMES
+---+---+---+---+
| 1 | 2 | 3 | 4 |
+---+---+---+---+
| Q | W | E | R |
+---+---+---+---+
| A | S | D | F |
+---+---+---+---+
| Z | X | C | V |
+---+---+---+---+

MAPPED TO
+---+---+---+---+
| X | Y | B |R1 |
+---+---+---+---+
| V | U | M |L1 |
+---+---+---+---+
| L | D | R |RSB|
+---+---+---+---+
|L2 | A |R2 |LST|
+---+---+---+---+
*/

void get_key(){
    
    if(inputs.A > 0){
        cpu.key_active = true;
        keypad[0x0] = 1;
        return;
    }else{
        keypad[0x0] = 0;
        cpu.key_active = false;
    }
    if(inputs.X > 0){
        cpu.key_active = true;
        keypad[0x1] = 1;
        return;
    }else{
        keypad[0x1] = 0;
        cpu.key_active = false;
    }
    if(inputs.Y > 0){
        cpu.key_active = true;
        keypad[0x2] = 1;
        return;
    }else{
        keypad[0x2] = 0;
        cpu.key_active = false;
    }
    if(inputs.B > 0){
        cpu.key_active = true;
        keypad[0x3] = 1;
        return;
    }else{
        keypad[0x3] = 0;
        cpu.key_active = false;
    }
    if(inputs.View > 0){
        cpu.key_active = true;
        keypad[0x4] = 1;
        return;
    }else{
        keypad[0x4] = 0;
        cpu.key_active = false;
    }
    if(inputs.Up > 0){
        cpu.key_active = true;
        keypad[0x5] = 1;
        return;
    }else{
        keypad[0x5] = 0;
        cpu.key_active = false;
    }
    if(inputs.Menu > 0){
        cpu.key_active = true;
        keypad[0x6] = 1;
        return;
    }else{
        keypad[0x6] = 0;
        cpu.key_active = false;
    }
    if(inputs.Left > 0){
        cpu.key_active = true;
        keypad[0x7] = 1;
        return;
    }else{
        keypad[0x7] = 0;
        cpu.key_active = false;
    }
    if(inputs.Down > 0){
        cpu.key_active = true;
        keypad[0x8] = 1;
        return;
    }else{
        keypad[0x8] = 0;
        cpu.key_active = false;
    }
    if(inputs.Right > 0){
        cpu.key_active = true;
        keypad[0x9] = 1;
        return;
    }else{
        keypad[0x9] = 0;
        cpu.key_active = false;
    }
    if(inputs.L2 > -1){
        cpu.key_active = true;
        keypad[0xA] = 1;
        return;
    }else{
        keypad[0xA] = 0;
        cpu.key_active = false;
    }
    if(inputs.R2 > -1){
        cpu.key_active = true;
        keypad[0xB] = 1;
        return;
    }else{
        keypad[0xB] = 0;
        cpu.key_active = false;
    }
    if(inputs.R1 > 0){
        cpu.key_active = true;
        keypad[0xC] = 1;
        return;
    }else{
        keypad[0xC] = 0;
        cpu.key_active = false;
    }
    if(inputs.L1 > 0){
        cpu.key_active = true;
        keypad[0xD] = 1;
        return;
    }else{
        keypad[0xD] = 0;
        cpu.key_active = false;
    }
    if(inputs.RightStickBut > 0){
        cpu.key_active = true;
        keypad[0xE] = 1;
        return;
    }else{
        keypad[0xE] = 0;
        cpu.key_active = false;
    }
    if(inputs.LeftStickBut > 0){
        cpu.key_active = true;
        keypad[0xF] = 1;
        return;
    }else{
        keypad[0xF] = 0;
        cpu.key_active = false;
    }

}

void check_key_active(){
    if(inputs.Up > 0 || inputs.Right > 0 || inputs.Down > 0 || inputs.Left > 0){
        cpu.key_active = true;
    }else{
        cpu.key_active = false;
    }
}