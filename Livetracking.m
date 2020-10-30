vid = videoinput('macvideo',1); %taking video input this can be changed if you are windows operating system
preview(vid);
start(vid); 
set(vid, 'ReturnedColorSpace', 'RGB'); 
X=figure('Name','Checking for Eyes pupils'); % This figure for detecting the eyes pupils
X;
pause(5);

while(ishandle(X))
    
    instant_snap=getsnapshot(vid); %taking a snap shot of your vidoe
    
    subplot(2,1,1);
    
    imshow(instant_snap);
    title("Original live");
    [centersStrong1F,radiiStrong1,centersStrong2F, radiiStrong2,No_face] = gogoDetection(instant_snap);
    
    subplot(2,1,2);
    if(No_face)
        imshow(instant_snap);
        title("No Face Detected, please fix your face"); %if there is no face.
    else
        
        imshow(instant_snap);
    
        viscircles(centersStrong1F, round(radiiStrong1),'EdgeColor','r');
        viscircles(centersStrong2F, round(radiiStrong2),'EdgeColor','b');
        title("Detected your eyes");
    end
    drawnow;
end
delete(vid);