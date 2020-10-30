function [centersStrong1F,radiiStrong1,centersStrong2F, radiiStrong2,No_face] = gogoDetection(A)
No_face=0;
kaka=vision.CascadeObjectDetector();
kaka.MergeThreshold=25; %increase criteria for faces

BBOX=step(kaka,A);   % <<<<<<   the location el Face
if( isempty(BBOX)) %if there is no face
    
    
  No_face=1;
  centersStrong1F=0;
  radiiStrong1=0;
  centersStrong2F=0;
  radiiStrong2=0;
  %for the sake of avoiding errors
  
else
Agray=rgb2gray(A);

Face_1=Agray(BBOX(1,2):BBOX(1,2)+BBOX(1,3),BBOX(1,1):BBOX(1,1)+BBOX(1,3));  % <<<<<<  2at3t el Face

out=zeros(2,4);
siz=int16(BBOX(1,3));
                            % <<<<<<<  ratios for eye >>>>>>>>
     oben=.28;
     unten=0.5;
%    Create Bounding Box for Right Eyes
    left=0.2;
    right=0.58;
 
    out(2,:)=[out(2,1)+siz*left,out(2,2)+siz*oben,siz*(1-right-left),siz*(1-oben-unten)];
    
%    Create Bounding Box for Left Eyes
     left=0.58;
    right=0.2;
    out(1,:)=[out(1,1)+siz*left,out(1,2)+siz*oben,siz*(1-right-left),siz*(1-oben-unten)];  
    

  

    
    Eye1=Face_1(out(1,2):out(1,2)+out(1,3),out(1,1):out(1,1)+out(1,3));
    Eye2=Face_1(out(2,2):out(2,2)+out(2,3),out(2,1):out(2,1)+out(2,3));
    
   
    
    Eyebw1= imbinarize(histeq(Eye1),0.25);
    Eyebw2= imbinarize(histeq(Eye2),0.25);
    %{
    se=strel('disk',2);
    Eyebw1=imclose(Eyebw1,se);
    Eyebw2=imclose(Eyebw1,se);
    
   
    %}
    
    %       >>>>>>>>>>   Process for Eye number 1  <<<<<<<<<<<
    
    
    
    EyebwFILT1 = bwareaopen(Eyebw1,1000); %EyebwFILT=medfilt2(Eyebw,[1 15]);
    
  
    max1=0;
    [centers1, radii1, metric2 ]= imfindcircles(EyebwFILT1,[5 50],'ObjectPolarity','dark');
    %finding the largest radius in BW image
    for i=1:size(radii1,1)
        if(radii1(i,1)>max1)
            centersStrong1 = centers1(i,:); 
            radiiStrong1 = radii1(i);
            %metricStrong1 = metric1(i);
            max1=radii1(i);
            
        end
        
        
    end
    
    %           >>>>>>>>>>   Process for Eye number 2  <<<<<<<<<<<
    
    
    EyebwFILT2 = bwareaopen(Eyebw2,1000); %EyebwFILT=medfilt2(Eyebw,[1 15]);

    
    max2=0;
    [centers2, radii2,metric2] = imfindcircles(EyebwFILT2,[5 50],'ObjectPolarity','dark');
    
    %finding the largest radius in BW image
    for i=1:size(radii2,1)
        if(radii2(i,1)>max2)
            centersStrong2 = centers2(i,:); 
            radiiStrong2 = radii2(i);
            max2=radii2(i);
            
        end
        
        
    end
   
    
    
    %First Eye
    
    centersStrong1F(1,1)=centersStrong1(1,1)+BBOX(1,1)+out(1,1);%some columns to right
    centersStrong1F(1,2)=centersStrong1(1,2)+BBOX(1,2)+out(1,2);%some rows down
    
    
   
    %Second Eye
    
    centersStrong2F(1,1)=centersStrong2(1,1)+BBOX(1,1)+out(2,1);%some columns to right
    centersStrong2F(1,2)=centersStrong2(1,2)+BBOX(1,2)+out(2,2);%some rows down
    
end

    
    
    
    
    