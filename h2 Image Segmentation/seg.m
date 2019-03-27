% seg.m - Image Segmentation by
% 1. Gonzalez,  2. Otsu  [low, high, T1, T2-1]
close all;clear;clc;
imgs=[".\imgs\ler.raw",".\imgs\whorl.raw",".\imgs\rloop.raw",".\imgs\linsFN.raw",".\imgs\linsfT.raw",".\imgs\Frogs.jpg"];
r=[100,512,512,640,640,3264];
c=[100,512,512,896,896,2448];

for no=1:5
    clc;
    figure;
    fin=fopen(imgs(no),'r');
    m=r(no); n=c(no);
    I=fread(fin,n*m,'uint8=>unit8');  fclose(fin); A=reshape(I,n,m); A=A';

  
    % 1. Gonzalez
    T1=(min(min(A))+max(max(A)))/2;
    done=false;
    delta=0.5;    % a small number
    while ~done
        g=(A>=T1);
        tx=(mean(A(g))+mean(A(~g)))/2;
        done=abs(T1-tx) < delta;
        T1=tx;
    end
    for i=1:m  
      for j=1:n if (A(i,j)<T1) B1(i,j)=30; else B1(i,j)=180; end; end
    end
    % 2. Otsu ~ graythresh(A)
    T2=Otsu(A,m,n); % T1, T2
    for i=1:m  
      for j=1:n if (A(i,j)<=T2) B2(i,j)=30; else B2(i,j)=180; end; end
    end
    subplot(2,2,1)
    imshow(double(A)/255)
    M=256;  % 256 bins 
    subplot(2,2,2)
    hist(I,M)
    title('Histogram of Image Scene')
    subplot(2,2,3)
    imshow(double(B1)/255)
    title('Gonzalez Segmentation with T=131')
    subplot(2,2,4)
    imshow(double(B2)/255)
    title('Otsu Segmentation with T=131')

end
% 5. JPEG
    clc;
    figure;
    m=c(6); n=r(6);  
    I=imread(imgs(6)); 
    R=I(:,:,1);
    G=I(:,:,2);
    B=I(:,:,3);
    
    allBlack = zeros(size(I, 1), size(I, 2), 'uint8');
    just_red = cat(3, R, allBlack, allBlack);
    just_green = cat(3, allBlack, G, allBlack);
    just_blue = cat(3, allBlack, allBlack, B);
  
    
    % 1. Gonzalez
    for p=1:4
        if p==1
            A=rgb2gray(I);
        elseif p==2
            A=R; 
        elseif p==3
            A=G; 
        else
            A=B;
        end
        T1=(min(min(A))+max(max(A)))/2;
        done=false;
        delta=0.5;    % a small number
        while ~done
            g=(A>=T1);
            tx=(mean(A(g))+mean(A(~g)))/2;
            done=abs(T1-tx) < delta;
            T1=tx;
        end
        for i=1:m  
          for j=1:n if (A(i,j)<T1) B1(i,j,p)=30; else B1(i,j,p)=180; end; end
        end
    end
    % 2. Otsu ~ graythresh(A)
    %T2=Otsu(A,m,n); % T1, T2
    T2=[graythresh(I)*256,graythresh(R)*256,graythresh(G)*256,graythresh(B)*256];
    for p=1:4
        if p==1
            A=rgb2gray(I);
        elseif p==2 
            A=R; 
        elseif p==3
            A=G; 
        else
            A=B;
        end
        for i=1:m  
         for j=1:n if (A(i,j)<=T2(p)) B2(i,j,p)=30; else B2(i,j,p)=180; end; end
        end
    end
    for i=1:m  
          for j=1:n if (B1(i,j,2)==30||B1(i,j,3)==30||B1(i,j,4)==30) C_R(i,j,1)=I(i,j,1);C_G(i,j,1)=I(i,j,2);C_B(i,j,1)=I(i,j,3); else C(i,j,:)=30; end; end
    end
    for i=1:m  
          for j=1:n if (B2(i,j,2)==30||B2(i,j,3)==30||B2(i,j,4)==30) D_R(i,j,1)=I(i,j,1);D_G(i,j,1)=I(i,j,2);D_B(i,j,1)=I(i,j,3); else D(i,j,:)=30; end; end
    end
    C = cat(3, C_R, C_G, C_B);
    D = cat(3, D_R, D_G, D_B);
    
    subplot(4,4,1)
    imshow(double(I)/255)
    subplot(4,4,2)
    imshow(double(just_red)/255)
    subplot(4,4,3)
    imshow(double(just_blue)/255)
    subplot(4,4,4)
    imshow(double(just_green)/255)
    M=256;  % 256 bins 
    subplot(4,4,5)
    imhist(rgb2gray(I))
    title('Histogram of Image Scene(Grayscale)')
    subplot(4,4,6)
    imhist(I(:,:,1))
    title('Histogram of R Channel')
    subplot(4,4,7)
    imhist(I(:,:,2))
    title('Histogram of G Channel')
    subplot(4,4,8)
    imhist(I(:,:,3))
    title('Histogram of B Channel')
    subplot(4,4,9)
    imshow(double(C)/255)
    title('Gonzalez Segmentation with T=131(I)')
    subplot(4,4,10)
    imshow(double(B1(:,:,2))/255)
    title('Gonzalez Segmentation with T=131(R)')
    subplot(4,4,11)
    imshow(double(B1(:,:,3))/255)
    title('Gonzalez Segmentation with T=131(G)')
    subplot(4,4,12)
    imshow(double(B1(:,:,4))/255)
    title('Gonzalez Segmentation with T=131(B)')
    subplot(4,4,13)
    imshow(double(D)/255)
    title('Otsu Segmentation with T=131(I)')
    subplot(4,4,14)
    imshow(double(B2(:,:,2))/255)
    title('Otsu Segmentation with T=131(R)')
    subplot(4,4,15)
    imshow(double(B2(:,:,3))/255)
    title('Otsu Segmentation with T=131(G)')
    subplot(4,4,16)
    imshow(double(B2(:,:,4))/255)
    title('Otsu Segmentation with T=131(B)')
    
