function petseg_main(input_file,output_dir)
% The main function of PetSeg
% INPUT:   input_file  the PET image to be segmented
% OUTPUT:  segedmat	 
%
% input_file is supposed to be named according to the same convention as used in  PETSEG - Training data, such as:
% clinical_1, clinical_2, phantom_1, phantom_2, Simu_1, Simu_2, etc
%
% examples(Window):
% input_file='clinical_1.nii';
% output_dir='D:\data\PET_liu\send_new\Feat_RF\output\';
%
% examples(Linux):
% input_file='clinical_2.nii';
% output_dir='/mysoft/PET_liu/Feat_RF-master/output/';

if strcmpi(computer,'PCWIN') |strcmpi(computer,'PCWIN64')
  file_slash='\';
else
  file_slash='/';
end
dirname = fileparts(mfilename('fullpath')); % Current directory
addpath(genpath(dirname));  % Add all subdirectory

TestImg=load_nii(input_file);
%disp('Get the features of the test sample:');
feat_gray=featextract(TestImg.img,'gray');
file_type = 'Unknown';
if ( strncmpi(input_file,'clinical',8) == 1 )
  file_type = 'Clinical';
end
if ( strncmpi(input_file,'simu',4) == 1 )
  file_type = 'Simu';
end
if ( strncmpi(input_file,'phantom',7) == 1 )
  file_type = 'Phantom';
end
file_type
switch(file_type)
  case 'Clinical'
    load('Model_Gray_Clin.mat');
    X_tst=feat_gray;
  case 'Phantom'
    load('Model_Gray_Phantom.mat');
    X_tst=feat_gray;  
  case 'Simu'
    load('Model_Gray_Simu.mat');
    X_tst=feat_gray; 
  otherwise
    error('Cannot determine file type')
end
%disp('Classificating the voxels:');
Y_hat=classRF_predict(X_tst,model);
temp=TestImg;
SegResult=GetSegResult(temp.img,Y_hat);
temp.img=SegResult;

if ~(exist(output_dir, 'dir') )        mkdir(output_dir);  end
    save_nii(temp,[output_dir file_slash 'Result_' input_file(1:end-4) '.nii']);
end