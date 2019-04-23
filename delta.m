% I=imread('1.jpg')
% imshow(I)
% title('Input Image')
% I1=rgb2gray(I);
% figure,imshow(I1)
% title('gray converted Image')
% 
% I2=imread('2.jpg')
% imshow(I2)
% title('Input Image')
% I22=rgb2gray(I2);
% figure,imshow(I22)
% title('gray converted Image')
% Delta_I = int32(int8(I22) - int8(I1));
% 
% for i = 1:440
%     for a = 1:700
%         if Delta_I(i,a) <= -15
%             Delta(i,a) = 50;
%         elseif Delta_I(i,a) >=15 
%             Delta(i,a) = 200; 
%         else
%             Delta(i,a) = 0;            
%         end
%     end
% end
% 
% figure,imshow(Delta);

% images to video (https://nl.mathworks.com/matlabcentral/answers/309541-how-can-i-convert-image-sequence-to-video)

%% Reading n images into a matrix and convert to greyscale
clear
num_images = 120;
image_divider = 4;
y= (num_images/image_divider);
movie_obj = VideoWriter('TestMovie.avi');
movie_obj_2 = VideoWriter('TestMovie_major.avi');
movie_obj_3 = VideoWriter('TestMovie_major_net.avi');
open(movie_obj);
for n=1:num_images
k = sprintf('in%06d.jpg',n);
Images{n} = imread(k);
GreyImages{n} = rgb2gray(Images{n});
Delta_event{n} = Images{n};
major_event{n} = Images{n};
major_event_net{n} = Images{n};

if n ==1
    Delta{n} = int32(int8(GreyImages{n}) - int8(GreyImages{n}));
else
    Delta{n} = int32(int8(GreyImages{n}) - int8(GreyImages{n-1}));
end 

for i = 1:440
    for a = 1:700
        if Delta{n}(i,a) < (-15)
            Delta_event{n}(i,a,2) =  50; %Images{n}(i,a); %50;
            Event{n}(i,a) = 1;
        elseif Delta{n}(i,a) > 15 
            Delta_event{n}(i,a) = 200; %Images{n}(i,a); %200; 
            Event{n}(i,a) = 1;
        else
            Delta_event{n}(i,a,:) = 0; %Images{n}(i,a,:);  
            Event{n}(i,a) = 0;    
        end
        if mod(n,8) == 0
            Event_8 = Event{n}(i,a) + Event{n-1}(i,a)+ Event{n-2}(i,a)+ Event{n-3}(i,a)+ Event{n-4}(i,a)+ Event{n-5}(i,a)+ Event{n-6}(i,a)+ Event{n-7}(i,a);
            Event_net = Delta{n}(i,a) + Delta{n-1}(i,a)+ Delta{n-2}(i,a)+ Delta{n-3}(i,a)+ Delta{n-4}(i,a)+ Delta{n-5}(i,a)+ Delta{n-6}(i,a)+ Delta{n-7}(i,a);

            if Event_8 > 2
                major_event{n}(i,a,1) = 200;
            else
                major_event{n}(i,a,:) = 0; %Images{n}(i,a,:); 
            end 
            
             if Event_net > 35
                major_event_net{n}(i,a,1) = 200;
            else
                major_event_net{n}(i,a,:) = 0; %Images{n}(i,a,:); 
            end            
           % y=y+1;
        else
            major_event{n}(i,a,:) = 0; %Images{n}(i,a,:); 
            major_event_net{n}(i,a,:) = 0; %Images{n}(i,a,:); 
        end 
    end
end 
%figure,imshow(major_event{n});
writeVideo(movie_obj, Delta_event{n});
end

close(movie_obj);
open(movie_obj_2);

for d = 1:y
    Main_major_event{d} = major_event{d*image_divider};
   % figure,imshow(Main_major_event{d});
    writeVideo(movie_obj_2, Main_major_event{d});
end  
close(movie_obj_2);

open(movie_obj_3);

for p = 1:y
    Main_major_event_net{p} = major_event_net{p*image_divider};
    %figure,imshow(Main_major_event_net{p});
    writeVideo(movie_obj_3, Main_major_event_net{p});
end  
close(movie_obj_3);
