bool running = true;
bool paused = false;

int emu_run(){
    cpu_init();
    bus_init();
    while(running){
        if(paused){
            continue;
        }
        if(cpu.regs.dt > 0){
            cpu.regs.dt--;
        }
        for(int i = 0;i<Settings_CPU_cycle;i++){
            if(!cpu_step()){
                print("CPU Stopped");
                return -3;
            }
        }
        sleep(1);
    }
    return 0;
}