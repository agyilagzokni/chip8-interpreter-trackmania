class virtual_keyboard{
    int rows;
    int cols;
    array<array<string>> button_texts;
    int button_size;

    virtual_keyboard(int r, int c, int b){
        this.rows = r;
        this.cols = c;
        this.button_size = b;
        button_texts = array<array<string>>(rows, array<string>(cols, ""));
    }
}