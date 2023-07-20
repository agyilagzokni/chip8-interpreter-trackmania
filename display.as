class display {
    private int c_displayWidth;
    private int c_displayHeight;
    private int c_displayPixel;
    private int c_displayX;
    private int c_displayY;
    private array<array<uint8>> pixelColors;
    private vec4 defaultBgColor;

    int Width{
        get const {return c_displayWidth;}
        set{
            c_displayWidth = value;
        }
    }
    int Height{
        get const {return c_displayHeight;}
        set{
            c_displayHeight = value;
        }
    }
    int Pixel{
        get const {return c_displayPixel;}
        set{
            c_displayPixel = value;
        }
    }
    int X{
        get const {return c_displayX;}
        set{
            c_displayX = value;
        }
    }
    int Y{
        get const {return c_displayY;}
        set{
            c_displayY = value;
        }
    }
    array<array<uint8>> PixelColors{
        get const {return pixelColors;}
        set{pixelColors = value;}
    }
    vec4 Background{
        get const {return defaultBgColor;}
        set{defaultBgColor = value;}
    }

    display(int displayWidth, int displayHeight, int displayPixel, int displayX, int displayY){
        Width = displayWidth;
        Height = displayHeight;
        Pixel = displayPixel;
        X = displayX;
        Y = displayY;
        PixelColors = array<array<uint8>>(displayWidth, array<uint8>(displayHeight, 0));
        Background = vec4(0, 0, 0, 255);
    }


    void renderDisplay(){
        for(int i = 0; i < c_displayWidth; i++){
            for(int j = 0; j < c_displayHeight; j++){
                nvg::BeginPath();
                nvg::Rect(c_displayX + i * c_displayPixel, c_displayY + j * c_displayPixel, c_displayPixel, c_displayPixel);
                nvg::FillColor(pixelColors[i][j] == 0 ? vec4(0, 0, 0, 255) : vec4(255, 255, 255, 255));
                nvg::Fill();
                nvg::ClosePath();
            }
        }
    }
    void setPixelColor(int x, int y, uint8 color){
        if(x >= c_displayWidth or y >= c_displayHeight){
            pixelColors[x % Width][y % Height] = color;
            return;
        }
        pixelColors[x][y] = color;
        //pixelColors[(x % c_displayWidth) + c_displayWidth * (y % c_displayHeight)] = color;
    }

    uint8 getPixelColor(int x, int y){
        if(x >= c_displayWidth or y >= c_displayHeight){
            return pixelColors[x % Width][y % Height];
        }
        return pixelColors[x][y];
        //return pixelColors[(x % c_displayWidth) + c_displayWidth * (y % c_displayHeight)];
    }

    void resetDisplay(){
        for(int i = 0;i<c_displayWidth;i++){
            for(int j = 0;j<c_displayHeight;j++){
                pixelColors[i][j] = 0;
            }
        }
    }
    void drawStraightLine(int x1, int y1, int x2, int y2){
        if(x1 == x2 || y1 == y2){
            if(x1 == x2){
                for(int i = 0;i<c_displayHeight;i++){
                    setPixelColor(x1, i, 1);
                }
            }else{
                for(int i = 0;i<c_displayWidth;i++){
                    setPixelColor(i, y1, 1);
                }
            }
        }
    }
}