array<uint16> stack(16);

void stack_push(uint16 addr){
    stack[cpu.regs.sp] = addr;
    cpu.regs.sp++;
    
}
uint16 stack_pop(){
    cpu.regs.sp--;
    uint16 data = stack[cpu.regs.sp];
    
    return data;
}