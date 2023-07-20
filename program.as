string program_name = "/5-quirks.ch8";
string path = IO::FromDataFolder("Plugins/chip8/roms");
IO::File f;

void load_program(){
    f.Open(path + program_name, IO::FileMode::Read);
    int program_size = f.ReadToEnd().Length;
    f.SetPos(0);
    for(int i = 0;i<program_size;i++){
        memory[0x200 + i] = f.Read(0x1).ReadUInt8();
    }
    f.Close();
}