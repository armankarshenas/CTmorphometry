%% This script compress the images using bit removal specified below
function [] = Compression()
%% Specifications 
clear
clc
close all
% specify this using the Randomness.m function
bit_removed = 10;
% specify the path to the main directory with the scans
Path = "";
% specify the path for compressed files to be stored 
destin_path = "";
cd(Path);
all_d = dir(pwd);
%% The loop over all files 
for direc=1:length(all_d)
    if (all_d(direc).isdir == 1) && (length(all_d(direc).name) >5)
        % First sort out the naming
        long_name = all_d(direc).name;
        New_name = long_name;
        fprintf("%s \n",New_name);
        cd(all_d(direc).folder+"/"+long_name);
        mydir =pwd;
        dirPattern = fullfile(mydir,'*.tif');
        TIF = dir(dirPattern);
        cd(destin_path)
        mkdir(New_name)
        cd(New_name)
        for i=1:length(TIF)
            % load the image
            if (TIF(i).isdir ~= 1)
                I = imread(TIF(i).folder+"/"+TIF(i).name);
                fprintf("%s \n",TIF(i).name);
                BI = uint16(zeros(size(I,1),size(I,2)));
                for dim_1 = 16:-1:16-bit_removed
                    BI = BI + bitget(I,dim_1).*(2^(dim_1-bit_removed));
                end
                I = BI;
                clear BI;
                I = uint8(I);
                I = imadjust(I,stretchlim(I),[]);
                name = TIF(i).name;
                name = split(name,".");
                name = name{1};
                name = name + ".jpg";
                imwrite(I,name,'jpeg');
                
            end
        end
        
    end
end
end