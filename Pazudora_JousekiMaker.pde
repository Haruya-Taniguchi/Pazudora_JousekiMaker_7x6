PImage[] drop_pic = new PImage[6];
PFont font;
int[][] board = new int[7][6];//火,光,木,闇,水,回復  0,1,2,3,4,5,6
int[][] board_re = new int[7][6];
boolean[][] mass_t = new boolean[7][6];//消えるドロップならばtrueに
float drop_dia;//ドロップの直径
int[] move_drop = new int[2];
int[] co = new int[2];
int combo = 0;//何コンボしたかを入れる変数
int provisional = 0;//変数同士の入れ替えに使用
boolean moved = false;//一度マウスを離したらずっとtrue
int draws = 0;//フレームをカウント
boolean not_erase = true;//ドロップを消す処理をしている間false
boolean not_down = true;
boolean fin=false;
int i, j, k;
boolean judge = true;
int[] ex_val = new int[7];//消えているドロップの数
boolean[][] mass = new boolean[7][6];//消えているか否かを判定
int mass_val = 0;
int drop_x=0, drop_y=0;
void setup() {
  textAlign(CENTER, CENTER);
  imageMode(CENTER);
  drop_pic[0] = loadImage("block_red.png");
  drop_pic[1] = loadImage("block_light.png");
  drop_pic[2] = loadImage("block_green.png");
  drop_pic[3] = loadImage("block_dark.png");
  drop_pic[4] = loadImage("block_blue.png");
  drop_pic[5] = loadImage("block_life.png");
  font=loadFont("ProcessingSansPro-Regular-48.vlw");
  size(525, 600, P2D);
  textFont(font);
  drop_dia=width/7;
  h=width/7;
  w=width/3;
  ui_space=height-drop_dia-h;
  pd_space=ui_space+drop_dia;
  frameRate(60);
  for (i = 0; i < 6; i++)//最初のドロップの配置 
  {
    for (j = 0; j < 7; j++) 
    {
      board[j][i] = int(random(0, 6));
      board_re[j][i] = board[j][i];
      mass[j][i] = true;
      mass_t[j][i] = false;
    }
  }
  for (int i=0; i<14; i++)//コンボ表示
  {
    comboTxt_t[i]=255;
  }
}

void draw() {
loop: //消し終わったか否かを判定
  for (int j=0; j<7; j++) 
  {
    for (int i=0; i<6; i++) 
    {
      if (moved&&(!mass[j][i]!=mass_t[j][i])) {
        break loop;
      }
      if (j==6&&i==5&&moved&&not_erase&&button[2]) {
        fin=true;
      }
    }
  }
  //deployモード時の処理
  if (mousePressed&&button[1])
  {
    if (mouseY<ui_space)
    {
      drop_put[0]=int(mouseX/drop_dia);
      drop_put[1]=int(mouseY/drop_dia);

      for (j=0; j<7; j++)
      {
        for (i=0; i<6; i++)
        {
          if (mouseX<width&&mouseX>0&&mouseY>0&&mouseY<ui_space)
          {
            board[drop_put[0]][drop_put[1]]=deside;
          }
          board_re[j][i]=board[j][i];
        }
      }
    }
  }

  //消えるドロップの判定
  for (i = 0; i < 6; i++) 
  {
    for (j = 0; j < 7; j++) 
    {
      if (board[j][i] == 6) 
      {
        mass[j][i] = false;
      }
    }
  }

  for (i=0; i<6; i++)
  {
    for (j=0; j<7; j++)
    {
      drop_x=0;
      drop_y=0;
      //消すか否かのみ判定
      if (j<5)
      {
        for (int a=1; a<=2; a++)
        {
          if (board[j][i]==board[j+a][i])
          {
            drop_x++;
          } else {
            break;
          }
        }
      } else
        if (j==5)
        {    
          if (board[j][i]==board[j+1][i])
          {
            drop_x++;
          }
        }
      if (j>1)
      {
        for (int a=1; a<=2; a++)
        {
          if (board[j][i]==board[j-a][i])
          {
            drop_x++;
          } else {
            break;
          }
        }
      } else
        if (j==1)
        {
          if (board[j][i]==board[j-1][i])
          {
            drop_x++;
          }
        }

      if (i<4)
      {
        for (int d=1; d<=2; d++)
        {
          if (board[j][i]==board[j][i+d])
          {
            drop_y++;
          } else {
            break;
          }
        }
      } else
        if (i==4)
        {    
          if (board[j][i]==board[j][i+1])
          {
            drop_y++;
          }
        }
      if (i>1)
      {
        for (int d=1; d<=2; d++)
        {
          if (board[j][i]==board[j][i-d])
          {
            drop_y++;
          } else {
            break;
          }
        }
      } else
        if (i==1)
        {
          if (board[j][i]==board[j][i-1])
          {
            drop_y++;
          }
        }

      if (drop_x>=2||drop_y>=2)
      {
        mass_t[j][i]=true;
      } else {
        mass_t[j][i]=false;
      }
    }
  }
  draws++;
  background(53, 17, 32);
  bg();
  if (button[2])
  {
    //消す処理
    judge = true;
    if (moved && draws % 30 == 0 && !mousePressed)
    {
      not_erase = true;
      for (i = 0; i < 7 && judge; i++) {
        for (j = 0; j < 6 && judge; j++) {
          if (mass[i][j] && i < 5 && board[i][j] == board[i+1][j] && board[i][j] == board[i+2][j]&&board[i][j]!=6) {
            mass_judge(i, j);
            if (not_first)//コンボ数を表示するテキストの座標を保存
            {
              comboTxt_x[combo]=(i+1)*drop_dia;
              comboTxt_y[combo]=j*drop_dia;
              combo++;
            }
            judge = false;
            not_first = true;
          }
          if (mass[i][j] && j < 4 && board[i][j] == board[i][j+1] && board[i][j] == board[i][j+2]&&board[i][j]!=6) {
            mass_judge(i, j);
            if (not_first)
            {
              comboTxt_x[combo]=i*drop_dia;
              comboTxt_y[combo]=(j+1)*drop_dia;
              combo++;
            }
            judge = false;
            not_first = true;
          }
        }
      }
      //ドロップを落とす
      not_down=true;
      if (not_erase) {
        for (i = 0; i < 7; i++) {
          for (j = 5; j >= 0; j--) {
            if (mass[i][j]) {
              board[i][j + ex_val[i]] = board[i][j];
            } else {
              ex_val[i]++;
              not_down=false;
            }
          }
        }
        for (i = 0; i < 7; i++) {
          for (j = 0; j < 6; j++) {
            if (j < ex_val[i]) {
              board[i][j] = 6;
            }
            mass[i][j] = true;
          }
          ex_val[i] = 0;
        }
      }
    }

    if (not_erase && mousePressed && mouseX >= 0 && mouseX < width && mouseY >= 0 && mouseY < ui_space&&!fin) {
      //ドロップをドラッグする処理
      co[0] = int(mouseX / drop_dia);
      co[1] = int(mouseY / drop_dia);
      if (dist(mouseX, mouseY, co[0]*drop_dia + drop_dia/2, co[1]*drop_dia + drop_dia/2) < drop_dia/2) {
        change_drops(co[0], co[1], move_drop[0], move_drop[1]);
        for (i = 0; i < 2; i++) {
          move_drop[i] = co[i];
        }
      }
    }
  }
  GUI();
  display();
  combo();
}
void mousePressed() {
  if (button[1])
  {
    if (mouseY>pd_space)
    {
      deside=select;
    }
  }
  if (button[2]&&ui_space>mouseY)
  {
    move_drop[0] = int(mouseX / drop_dia);
    move_drop[1] = int(mouseY / drop_dia);
  }
  if (mouseX>0&&mouseX<w&&mouseY<pd_space&&mouseY>ui_space)
  {
    ini();
    for (i = 0; i < 6; i++) {//ドロップ
      for (j = 0; j < 7; j++) {
        board[j][i]=int(random(6));
        board_re[j][i] = board[j][i];
        mass[j][i] = true;
        mass_t[j][i] = false;
      }
    }
    button[0]=true;
    button[1]=false;
    button[2]=false;
  } 
  if (mouseX>w&&mouseX<w*2&&mouseY<pd_space&&mouseY>ui_space)
  {
    ini();
    button[0]=false;
    button[1]=true;
    button[2]=false;
  } 
  if (mouseX>w*2&&mouseX<width&&mouseY<pd_space&&mouseY>ui_space)
  {
    ini();
    button[0]=false;
    button[1]=false;
    button[2]=true;
  }
}

void mouseReleased() {
  if (ui_space>mouseY)
  {
    moved = true;
    i = 0;
    j = -1;
  }
}

//mass_t[][]がtrueだがmass[][]がtrueの場合falseを代入して消し、その周囲にもそのようなドロップがあったら同じ処理をする。
void mass_judge(int x, int y) {
  if (mass[x][y]&& mass_t[x][y]) {
    mass[x][y] = false;
    if (y-1 >= 0 && board[x][y-1] == board[x][y] && mass_t[x][y]) {
      mass_judge(x, y-1);
    }
    if (x+1 < 7 && board[x+1][y] == board[x][y] && mass_t[x][y]) {
      mass_judge(x+1, y);
    }
    if (y+1 < 6 && board[x][y+1] == board[x][y] && mass_t[x][y]) {
      mass_judge(x, y+1);
    }
    if (x-1 >= 0 && board[x-1][y] == board[x][y] && mass_t[x][y]) {
      mass_judge(x-1, y);
    }
    not_erase = false;
  }
}

void change_drops(int x1, int y1, int x2, int y2) {
  if (board[x1][y1] != 6 && board[x2][y2] != 6) 
  {
    provisional = board[x1][y1];
    board[x1][y1] = board[x2][y2];
    board[x2][y2] = provisional;
  }
}
//ドロップを表示する関数
int drop_t=255;//ドロップの透明度
void display() {
  noStroke();
  for (i = 0; i < 6; i++) {
    for (j = 0; j < 7; j++) {
      if (board[j][i] != 6) {
        if ((j != move_drop[0] || i != move_drop[1] || mousePressed == false) && mass[j][i]) {
          if (fin) {
            if (drop_t>128)
              drop_t--;
            tint(255, drop_t);
          } else {
            tint(255, 255);
          }
          image(drop_pic[board[j][i]], j*drop_dia + drop_dia/2, i*drop_dia + drop_dia/2, drop_dia, drop_dia);
        } else if (mass[j][i]) {
          if (not_erase&&mouseY<ui_space&&button[2]&&!fin) {//ドラッグされているドロップの表示
            tint(255, 255);
            image(drop_pic[board[j][i]], mouseX, mouseY-drop_dia/4, drop_dia*1.3, drop_dia*1.3);
          } else {
            image(drop_pic[board[j][i]], j*drop_dia + drop_dia/2, i*drop_dia + drop_dia/2, drop_dia, drop_dia);
          }
        }
      }
    }
  }
}

void bg()
{
  for (int i=0; i<7; i++)
  {
    for (int j=0; j<6; j++)
    {
      if ((j+i)%2==0)
      {
        fill(54, 32, 33);
      } else {
        fill(91, 49, 30);
      }
      rect(float(i)*drop_dia, float(j)*drop_dia, drop_dia, drop_dia);
    }
  }
}
float[] comboTxt_t=new float[14];
float[] comboTxt_x = new float[14];
float[] comboTxt_y = new float[14];
boolean not_first = false;
void combo()
{
  for (int i=0; i<combo; i++)
  {
    //初めに消したドロップでなければコンボ数を表示
    if (comboTxt_t[i]>5&&not_first)
    {
      comboTxt_t[i]-=2.5;
      fill(255, comboTxt_t[i]);
      textSize(comboTxt_t[i]/10);
      text(i+2+"combo", comboTxt_x[i]+drop_dia/2, comboTxt_y[i]+drop_dia/2);
    }
  }
}

boolean operate()
{
  for (int i=0; i<7; i++)
  {
    for (int j=0; j<6; j++)
    {
      if (not_erase&&not_down==false)
      {
        return true;
      }
    }
  }
  return false;
}
void ini()
{
  if (moved)
  {
    moved=false;
  }
  fin=false;
  combo=0;
  drop_t=255;
  not_first=false;
  for (i=0; i<14; i++)
  {
    comboTxt_t[i]=255;
  }
  for (j=0; j<7; j++)
  {
    for (i=0; i<6; i++)
    {
      board[j][i]=board_re[j][i];
      mass[j][i] = true;
      mass_t[j][i] = false;
    }
  }
}
