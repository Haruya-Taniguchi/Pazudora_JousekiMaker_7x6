float h, w;
float space = 2;
float[] t = {100, 100, 100};
int[] drop_put = new int[2];
boolean[] button = {false, false, true};
color text_c = color(40, 25, 20);
color text_c_2 = color(244, 243, 241);
color button_c = color(72, 196, 160);
float ui_space;
float pd_space;
int select=0, deside=0;
void GUI()
{
  //モード選択用UI
  fill(button_c, t[0]);
  rect(0, ui_space, w, h, 7);
  fill(button_c, t[1]);
  rect(w, ui_space, w, h, 7);
  fill(button_c, t[2]);
  rect(w*2, ui_space, w, h, 7);
  textSize(16);
  if (button[0])
  {
    fill(text_c);
  } else {
    fill(text_c_2);
  }
  text("random", w/2, ui_space+drop_dia/2);
  if (button[1])
  {
    fill(text_c);
  } else {
    fill(text_c_2);
  }
  text("deploy", w/2+w, ui_space+drop_dia/2);
  if (button[2])
  {
    fill(text_c);
  } else {
    fill(text_c_2);
  }
  text("play", w/2+w*2, ui_space+drop_dia/2);
  for (int n=0; n<3; n++)
  {
    if (button[n])
    {
      t[n]=200;
    } else {
      t[n]=0;
    }
  }
  if (button[1])
  {
    //deployモードの際のドロップ選択部分
    fill(244, 243, 241, 20);
    rect(0, pd_space, width, drop_dia, 7);
    for (i=0; i<6; i++)
    {
      if (dist(mouseX, mouseY, drop_dia*i+drop_dia/2, pd_space+drop_dia/2)<drop_dia/2)
      {
        select=i;
      }
      if (i==deside)
      {
        tint(255, 255/2);
        image(drop_pic[deside], drop_dia*deside+drop_dia/2, pd_space+drop_dia/2, drop_dia, drop_dia);
      }
      if (i==select&&i!=deside&&pd_space<mouseY)
      {
        tint(255, 255);
        image(drop_pic[i], drop_dia*i+drop_dia/2, pd_space+drop_dia/2, drop_dia*1.1, drop_dia*1.1);
      }else
      if (i!=deside)
      {
        tint(255, 255);
        image(drop_pic[i], drop_dia*i+drop_dia/2, pd_space+drop_dia/2, drop_dia, drop_dia);
      }
    }
  }
}
