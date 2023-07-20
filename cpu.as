class registers{
    //general purpose registers through 0-F
    uint8 V0;
    uint8 V1;
    uint8 V2;
    uint8 V3;
    uint8 V4;
    uint8 V5;
    uint8 V6;
    uint8 V7;
    uint8 V8;
    uint8 V9;
    uint8 Va;
    uint8 Vb;
    uint8 Vc;
    uint8 Vd;
    uint8 Ve;
    uint8 Vf;

    uint16 I;

    //timers
    uint8 dt; //delay timer
    uint8 st; //sound timer

    //special registers
    uint16 pc; //program counter
    uint8 sp; //stack pointer
}

class CPU{
    registers regs;
    uint16 cur_opcode;
    bool halted;
    bool key_active = false;
    bool awaiting_key = false;
    uint8 awaiting_key_register;
}

CPU cpu;

void cpu_init(){
    cpu.regs.pc = 0x200; //start of most programs
    cpu.regs.sp = 0x0;
    load_program();
}

bool cpu_step(){
    uint16 pc = cpu.regs.pc;
    if(!isVirtualKeyboard){
        get_key();
    }else{
        get_key_v();
    }

    fetch_instruction();
    execute();

    //print("" + uint16ToHex(pc) + ": " + uint16ToHex(cpu.cur_opcode) + " I: " + uint16ToHex(cpu.regs.I) + " V0: " + uint8ToHex(cpu.regs.V0) + " V1: " + uint8ToHex(cpu.regs.V1) + " V2: " + uint8ToHex(cpu.regs.V2) + " V3: " + uint8ToHex(cpu.regs.V3) + " V4: " + uint8ToHex(cpu.regs.V4) + " V5: " + uint8ToHex(cpu.regs.V5) + " V6: " + uint8ToHex(cpu.regs.V6) + " V7: " + uint8ToHex(cpu.regs.V7) + " V8: " + uint8ToHex(cpu.regs.V8) + " V9: " + uint8ToHex(cpu.regs.V9) + " Va: " + uint8ToHex(cpu.regs.Va) + " Vb: " + uint8ToHex(cpu.regs.Vb) + " Vc: " + uint8ToHex(cpu.regs.Vc) + " Vd: " + uint8ToHex(cpu.regs.Vd) + " Ve: " + uint8ToHex(cpu.regs.Ve) + " Vf: " + uint8ToHex(cpu.regs.Vf));

    return true;
}

void fetch_instruction(){
    cpu.cur_opcode = bus_read_inst(cpu.regs.pc);
    cpu.regs.pc += 2;
}

void execute(){
    uint16 address = cpu.cur_opcode & 0x0FFF;
    uint8 data = cpu.cur_opcode & 0x00FF;
    uint8 reg1 = (cpu.cur_opcode & 0x0F00) >> 8; //needed for indexing the regs
    uint8 reg2 = (cpu.cur_opcode & 0x00F0) >> 4; //needed for indexing the regs
    uint8 param = cpu.cur_opcode & 0x000F;

    uint8 vx = cpu_get_reg(reg1); //actual values of the registers
    uint8 vy = cpu_get_reg(reg2); //actual values of the registers

    uint16 sum = vx + vy; //for carry dings
    switch((cpu.cur_opcode & 0xF000) >> 12){
        case 0x0:
            if(cpu.cur_opcode == 0x00E0){
                dis.resetDisplay();
            }else if(cpu.cur_opcode == 0x00EE){
                cpu.regs.pc = stack_pop();
            }else{
                //ignored
            }
            break;
        case 0x1:
            cpu.regs.pc = address;
            break;
        case 0x2:
            stack_push(cpu.regs.pc);
            cpu.regs.pc = address;
            break;
        case 0x3:
            if(vx == data){
                cpu.regs.pc += 2;
            }
            break;
        case 0x4:
            if(vx != data){
                cpu.regs.pc += 2;
            }
            break;
        case 0x5:
            if(vx == vy){
                cpu.regs.pc += 2;
            }
            break;
        case 0x6:
            cpu_set_reg(reg1, data);
            break;
        case 0x7:
            cpu_set_reg(reg1, vx + data);
            break;
        case 0x8: //0x8XYN
            if(param == 0){
                cpu_set_reg(reg1, vy);
            }else if(param == 1){
                cpu_set_reg(reg1, vx | vy);
                set_flag(0);
            }else if(param == 2){
                cpu_set_reg(reg1, vx & vy);
                set_flag(0);
            }else if(param == 3){
                cpu_set_reg(reg1, vx ^ vy);
                set_flag(0);
            }else if(param == 4){
                cpu_set_reg(reg1, sum & 0xFF);
                if(sum > 255){
                    set_flag(1);
                }else{
                    set_flag(0);
                }
            }else if(param == 5){
                cpu_set_reg(reg1, vx - vy);
                if(vx > vy){
                    set_flag(1);
                }else{
                    set_flag(0);
                }
            }else if(param == 6){
                cpu_set_reg(reg1, vy);
                cpu_set_reg(reg1, cpu_get_reg(reg1) >> 1);
                if(vx & 0x1 == 0x1){
                    set_flag(1);
                }else{
                    set_flag(0);
                }
                
            }else if(param == 7){
                cpu_set_reg(reg1, vy - vx);
                if(vy > vx){
                    set_flag(1);
                }else{
                    set_flag(0);
                }
            }else if(param == 0xE){
                cpu_set_reg(reg1, vy);
                cpu_set_reg(reg1, cpu_get_reg(reg1) << 1);
                if(vx & 0b10000000 == 0b10000000){
                    set_flag(1);
                }else{
                    set_flag(0);
                }
            }
            break;
        case 0x9:
            if(vx != vy){
                cpu.regs.pc += 2;
            }
            break;
        case 0xA:
            cpu.regs.I = address;
            break;
        case 0xB:
            cpu.regs.pc = cpu_get_reg(0x0) + address;
            break;
        case 0xC:
            cpu_set_reg(reg1, Math::Rand(0, 256) & data);
            break;
        case 0xD:
            //draw dings
            cpu.regs.Vf = 0;
            for(uint8 i = 0;i<param;i++){
                display_sprite(vx, vy + i, bus_read(cpu.regs.I + i), dis);
            }
            break;
        case 0xE:
            if(data == 0x9E){
                //print("(0xEx9E)waiting for key: " + vx);
                if(keypad[vx & 0xF] == 1){
                    cpu.regs.pc += 2;
                }
            }else if(data == 0xA1){
                //print("(0xExA1)waiting for key: " + vx);
                if(keypad[vx & 0xF] != 1){
                    cpu.regs.pc += 2;
                }
            }
            break;
        case 0xF:
            if(data == 0x07){
                cpu_set_reg(reg1, cpu.regs.dt);
            }else if(data == 0x0A){
                //print("(0xFx0A)waiting for keypress");
                if(cpu.key_active){
                    for(uint8 i = 0;i<16;i++){
                        if(keypad[i] == 1){
                            cpu_set_reg(reg1, i);
                            //print("key pressed: " + i); 
                        }
                    }
                }else{
                    cpu.regs.pc -= 2;
                }
            }else if(data == 0x15){
                cpu.regs.dt = vx;
            }else if(data == 0x18){
                cpu.regs.st = vx;
            }else if(data == 0x1E){
                cpu.regs.I += vx;
            }else if(data == 0x29){
                //sprite in the register Vx is added to I
                cpu.regs.I = 0x00 + (5 * (vx & 0xFF));
            }else if(data == 0x33){
                //binary coded decimal
                bus_write(cpu.regs.I, vx / 100);
                bus_write(cpu.regs.I + 1, (vx - ((vx / 100) * 100)) / 10);
                bus_write(cpu.regs.I + 2, vx % 10);

            }else if(data == 0x55){
                for(uint8 i = 0;i<=reg1;i++){
                    bus_write(cpu.regs.I++, cpu_get_reg(i));
                }
            }else if(data == 0x65){
                for(uint8 i = 0;i<=reg1;i++){
                    cpu_set_reg(i, bus_read(cpu.regs.I++));
                }
            }
            break;
    }
}

void display_sprite(int x, int y, uint8 data, display@ disp){
    for(int i = 8;i>=0;i--){
        uint8 prev = dis.getPixelColor(x + (8-i), y);
        disp.setPixelColor(x + (8-i), y, ((data & (1 << i)) >> i) ^ dis.getPixelColor(x + (8-i), y));
        if(prev == 1 && dis.getPixelColor(x + (8-i), y) == 0){
            cpu.regs.Vf = 1;
        }
    }
}

void set_flag(uint8 value){
    cpu.regs.Vf = value;
}

void cpu_set_reg(uint8 reg, uint8 data){
    switch(reg){
        case 0x0:
            cpu.regs.V0 = data;
            break;
        case 0x1:
            cpu.regs.V1 = data;
            break;
        case 0x2:
            cpu.regs.V2 = data;
            break;
        case 0x3:
            cpu.regs.V3 = data;
            break;
        case 0x4:
            cpu.regs.V4 = data;
            break;
        case 0x5:
            cpu.regs.V5 = data;
            break;
        case 0x6:
            cpu.regs.V6 = data;
            break;
        case 0x7:
            cpu.regs.V7 = data;
            break;
        case 0x8:
            cpu.regs.V8 = data;
            break;
        case 0x9:
            cpu.regs.V9 = data;
            break;
        case 0xA:
            cpu.regs.Va = data;
            break;
        case 0xB:
            cpu.regs.Vb = data;
            break;
        case 0xC:
            cpu.regs.Vc = data;
            break;
        case 0xD:
            cpu.regs.Vd = data;
            break;
        case 0xE:
            cpu.regs.Ve = data;
            break;
            
        case 0xF:
            cpu.regs.Vf = data;
            break;
        
    }
}

uint8 cpu_get_reg(uint8 reg){
    switch(reg){
        case 0x0:
            return cpu.regs.V0;
        case 0x1:
            return cpu.regs.V1;
        case 0x2:
            return cpu.regs.V2;
        case 0x3:
            return cpu.regs.V3;
        case 0x4:
            return cpu.regs.V4;
        case 0x5:
            return cpu.regs.V5;
        case 0x6:
            return cpu.regs.V6;
        case 0x7:
            return cpu.regs.V7;
        case 0x8:
            return cpu.regs.V8;
        case 0x9:
            return cpu.regs.V9;
        case 0xA:
            return cpu.regs.Va;
        case 0xB:
            return cpu.regs.Vb;
        case 0xC:
            return cpu.regs.Vc;
        case 0xD:
            return cpu.regs.Vd;
        case 0xE:
            return cpu.regs.Ve;
        case 0xF:
            return cpu.regs.Vf;  
    }
    return 0;
}