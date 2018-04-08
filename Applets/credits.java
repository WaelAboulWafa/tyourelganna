import java.awt.*;
import java.awt.event.*;
import java.applet.*;
import java.awt.image.*;
import java.io.*;
import java.net.*;

public class credits extends Applet implements Runnable {
  Image offscreenImage;
  Graphics offscreenGraphics;

  int x,y,dx,dy,diam,sizex,sizey,c,dc; 
  Image image;
  
  int imageX;
  int imageY;
  int dxImage;
  
  public void init() 
  {

   	image = getImage(getDocumentBase(), "Applets/MagicCG.png");
   	
    setBackground(Color.black);
   
     c=0; dc=1;
     
    imageX=0;
    imageY=0;
    dxImage=1;
  
     
    // Getting Parameters form the HTML
    sizex=getSize().width;
    sizey=getSize().height;

    offscreenImage = createImage(sizex,sizey);
    offscreenGraphics = offscreenImage.getGraphics();

    (new Thread(credits.this)).start();
    (new Thread(credits.this)).start();
//    (new Thread(credits.this)).start();
//    (new Thread(credits.this)).start();
//    (new Thread(credits.this)).start();
  }

  public void run() {
    while (true) {
      try {
        Thread.currentThread().sleep(50);
      }
      catch (InterruptedException e) {};

      synchronized(this) 
      {
        c+=dc;
        if ((c==0)||(c==255)) dc=-dc;
        
        imageX = imageX + dxImage;
        if ((imageX >= 28) || (imageX <= 5))
        {
        	if (imageX >= 28){dxImage=-dxImage;}
        	else{dxImage=Math.abs(dxImage);}
        	
        }
        
      }

      repaint();
    }
  }

  public void paint(Graphics g) 
  {


    offscreenGraphics.setColor(new Color(c,c,c));
    offscreenGraphics.fillRect(0,0,sizex,sizey);
    
    
//  offscreenGraphics.drawImage(image, 5, 5,50,50, this);    
    
    offscreenGraphics.drawImage(image, imageX, imageY+5,50,50, this);    
    
//    offscreenGraphics.drawImage(image, imageX, imageY+60,100,40, this);    
    
    
    offscreenGraphics.setColor(new Color(255-c,255-c,255-c));

  	Font font1 = new Font("Arial", Font.BOLD, 14);
	offscreenGraphics.setFont(font1);
    offscreenGraphics.drawString("MagicCG V 1.0",80,20); 
    

  	Font font2 = new Font("Arial", Font.PLAIN, 12);
	offscreenGraphics.setFont(font2);
	offscreenGraphics.setColor(new Color(255-c,0,0));
    offscreenGraphics.drawString("Developed by Accurate\u2122",80,35); 
    
    offscreenGraphics.setColor(new Color(0,0,255-c));
    offscreenGraphics.drawString("www.acccurate.com",80,50); 

  

    g.drawImage(offscreenImage, 0, 0, this);
  }

  public void update(Graphics g) 
  {
    paint(g);
  }

  public void destroy() 
  {
    offscreenGraphics.dispose();
  }
}