bool isVirtualKeyboard = true;

int width = 65;
int height = 32;
int pixel = 10;
int dX = 300;
int dY = 300;

display dis(width, height, pixel, dX, dY);
display keyb(29, 33, 10, 1200, 300);

auto app = cast<CTrackMania>(GetApp());
auto network = cast<CTrackManiaNetwork>(app.Network);

void Main(){
    

    //check that we're in a map
    if (network.ClientManiaAppPlayground is null || network.ClientManiaAppPlayground.Playground is null || network.ClientManiaAppPlayground.Playground.Map is null){
        print("you have to be in a map");
        return;
    }
    keyb.renderDisplay();
    emu_run();
    
}

vec2 mouse_coords;
vec2 projected_mouse_coords;

uint windowX = app.Viewport.cPixelSwapX;
uint windowY = app.Viewport.cPixelSwapY;

bool between(int min, int max, int n){
    return n >= min && n <= max;
}

bool isInXY(int x, int y){
    return between(keyb.X + (pixel * 7 * (x-1)), keyb.X + pixel * 7 * x, projected_mouse_coords.x) && between(keyb.Y + (pixel * 8 * (y-1)), keyb.Y + pixel * 8 * y, projected_mouse_coords.y);
}

void Update(float dt){
    if (network.ClientManiaAppPlayground is null || network.ClientManiaAppPlayground.Playground is null || network.ClientManiaAppPlayground.Playground.Map is null){
        return;
    }
    keyb.renderDisplay();
    mouse_coords = cast<CInputDeviceDx8Mouse@>(app.InputPort.ConnectedDevices[0]).PosInViewport;

    projected_mouse_coords.x = (-mouse_coords.x + 1) * windowX / 2;
    projected_mouse_coords.y = (-mouse_coords.y + 1) * windowY / 2;

    array<uint8> mem_for_chars = {0x05, 0x0A, 0x0F, 0x3C, 0x14, 0x19, 0x1E, 0x41, 0x23, 0x28, 0x2D, 0x46, 0x32, 0x00, 0x37, 0x4B};
    for(uint8 j = 0;j<=0xF;j++){
        for(uint8 i = 0;i<5;i++){
            display_sprite_keyb(1 + 7 * (j % 4), (j / 4) * 8 + 2+i, bus_read((mem_for_chars[j])+i), keyb);
        }
    }



    keyb.drawStraightLine(0, 0, 0, keyb.Height);
    keyb.drawStraightLine(keyb.Width-1, 0, keyb.Width-1, keyb.Height);
    keyb.drawStraightLine(0, 0, keyb.Width, 0);
    keyb.drawStraightLine(0, keyb.Height-1, keyb.Width, keyb.Height-1);

    keyb.drawStraightLine(7, 0, 7, keyb.Height);
    keyb.drawStraightLine(14, 0, 14, keyb.Height);
    keyb.drawStraightLine(21, 0, 21, keyb.Height);

    keyb.drawStraightLine(0, 8, keyb.Width, 8);
    keyb.drawStraightLine(0, 16, keyb.Width, 16);
    keyb.drawStraightLine(0, 24, keyb.Width, 24);

    
    dis.renderDisplay();
    
}

void display_sprite_keyb(int x, int y, uint8 data, display@ disp){
    for(int i = 8;i>=0;i--){
        uint8 prev = dis.getPixelColor(x + (8-i), y);
        disp.setPixelColor(x + (8-i), y, ((data & (1 << i)) >> i));
    }
}

void get_key_v(){
    auto vis = VehicleState::ViewingPlayerState();
    if(vis.InputGasPedal == 1){
        //print("mousex: " + projected_mouse_coords.x + " mousey: " + projected_mouse_coords.y);
        if(isInXY(1, 1)){
            cpu.key_active = true;
            keypad[0x1] = 1;
            return;
        }else{
            cpu.key_active = false;
            keypad[0x1] = 0;
        }
        if(isInXY(2, 1)){
            cpu.key_active = true;
            keypad[0x2] = 1;
            return;
        }else{
            cpu.key_active = false;
            keypad[0x2] = 0;
        }
        if(isInXY(3, 1)){
            cpu.key_active = true;
            keypad[0x3] = 1;
            return;
        }else{
            cpu.key_active = false;
            keypad[0x3] = 0;
        }
        if(isInXY(4, 1)){
            cpu.key_active = true;
            keypad[0xC] = 1;
            return;
        }else{
            cpu.key_active = false;
            keypad[0xC] = 0;
        }
        if(isInXY(1, 2)){
            cpu.key_active = true;
            keypad[0x4] = 1;
            return;
        }else{
            cpu.key_active = false;
            keypad[0x4] = 0;
        }
        if(isInXY(2, 2)){
            cpu.key_active = true;
            keypad[0x5] = 1;
            return;
        }else{
            cpu.key_active = false;
            keypad[0x5] = 0;
        }
        if(isInXY(3, 2)){
            cpu.key_active = true;
            keypad[0x6] = 1;
            return;
        }else{
            cpu.key_active = false;
            keypad[0x6] = 0;
        }
        if(isInXY(4, 2)){
            cpu.key_active = true;
            keypad[0xD] = 1;
            return;
        }else{
            cpu.key_active = false;
            keypad[0x02] = 0;
        }
        if(isInXY(1, 3)){
            cpu.key_active = true;
            keypad[0x7] = 1;
            return;
        }else{
            cpu.key_active = false;
            keypad[0x7] = 0;
        }
        if(isInXY(2, 3)){
            cpu.key_active = true;
            keypad[0x8] = 1;
            return;
        }else{
            cpu.key_active = false;
            keypad[0x8] = 0;
        }
        if(isInXY(3, 3)){
            cpu.key_active = true;
            keypad[0x9] = 1;
            return;
        }else{
            cpu.key_active = false;
            keypad[0x9] = 0;
        }
        if(isInXY(4, 3)){
            cpu.key_active = true;
            keypad[0xE] = 1;
            return;
        }else{
            cpu.key_active = false;
            keypad[0xE] = 0;
        }
        if(isInXY(1, 4)){
            cpu.key_active = true;
            keypad[0xA] = 1;
            return;
        }else{
            cpu.key_active = false;
            keypad[0xA] = 0;
        }
        if(isInXY(2, 4)){
            cpu.key_active = true;
            keypad[0x0] = 1;
            return;
        }else{
            cpu.key_active = false;
            keypad[0x0] = 0;
        }
        if(isInXY(3, 4)){
            cpu.key_active = true;
            keypad[0xB] = 1;
            return;
        }else{
            cpu.key_active = false;
            keypad[0x02] = 0;
        }
        if(isInXY(4, 4)){
            cpu.key_active = true;
            keypad[0xF] = 1;
            return;
        }else{
            cpu.key_active = false;
            keypad[0xF] = 0;
        }
    }else{
        for(uint i = 0;i<keypad.Length;i++){
            keypad[i] = 0;
        }
    }
}

string uint8ToHex(uint8 num){
    string sb = "";
    sb += decToHexLetter(num / 16);
    sb += decToHexLetter(num % 16);
    return sb;
}

string uint16ToHex(uint16 num){
    string sb = "";
    uint16 num_ = num;
    sb += decToHexLetter(num_ / 4096);
    num_ = num_ - ((num_ / 4096) * 4096);
    sb += decToHexLetter(num_ / 256);
    num_ = num_ - ((num_ / 256) * 256);
    sb += decToHexLetter(num_ / 16);
    sb += decToHexLetter(num_ % 16);
    return sb;
}
string decToHexLetter(uint8 num){
    if(num > 15){
        return "";
    }
    switch(num){
        case 10:
            return 'A';
        case 11:
            return 'B';
        case 12:
            return 'C';
        case 13:
            return 'D';
        case 14:
            return 'E';
        case 15:
            return 'F';
        default:
            return "" + num;
    }
}
