%Holly Ross
%Tracking a single ball while it is being juggled

close all; clear all; clc;

StartingFrame = 1;
EndingFrame = 489;

for b = 1: 1: 3
    ball(b).Xcentroid = [ ];
    ball(b).Ycentroid = [ ];
end

for k = StartingFrame : EndingFrame
    
    k
    
    rgb = imread(['juggle/img', sprintf('%2.3d',k),'.jpg']);
    
    imshow(rgb);
    hold on;
    
    % colorThresholder
    [BW,RGBmasked] = createMask(rgb);
    
    SEopen = strel('disk',1,8);
    SEclose = strel('disk',20,8);
    BW = imopen(BW,SEopen);
    BW = imclose(BW,SEclose);
    
    [labels,number] = bwlabel(BW,8);
    
    if number > 2
        
        Istats = regionprops(labels,'basic','Centroid');
        
        [values, index] = sort([Istats.Area],'descend');
        
        for b = 1: 1: 3
            det(b).Xcentroid = Istats(index(b)).Centroid(1);
            det(b).Ycentroid = Istats(index(b)).Centroid(2);
        end
        
        if k ==1;
            
            for b = 1: 1: 3
                ball(b).Xcentroid = [ball(b).Xcentroid det(b).Xcentroid];
                ball(b).Ycentroid = [ball(b).Ycentroid det(b).Ycentroid];
            end
        else
            for b = 1: 1: 3
                for d = 1: 1: 3
                    dist(d,b) = hypot(...
                        abs(ball(b).Xcentroid(end) - det(b).Xcentroid), ...
                        abs(ball(b).Ycentroid(end) - det(b).Ycentroid));
                end
            end
            
            [minValue, minIndex] = min(dist);
            
            for b = 1: 1: 3
                ball(b).Xcentroid = [ball(b).Xcentroid det(minIndex(b)).Xcentroid];
                ball(b).Xcentroid = [ball(b).Ycentroid det(minIndex(b)).Ycentroid];
                
            end
            
        end
        
        
    end
    
    
    hold on;
    rectangle('Position', [Istats(index(1)).BoundingBox], 'LineWidth', 2, 'EdgeColor', 'g');
    rectangle('Position', [Istats(index(2)).BoundingBox], 'LineWidth', 2, 'EdgeColor', 'r');
    rectangle('Position', [Istats(index(3)).BoundingBox], 'LineWidth', 2, 'EdgeColor', 'b');
    
    
    hold on;
    plot(Istats(index(1)).Centroid(1), 'r*');
    
    pause(0.0000000001);
    
end

pos1 = imread(['juggle/img', sprintf('%2.3d',k),'.jpg']);

imshow(pos1,'Border','tight');



