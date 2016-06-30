function SegResult = petseg_main(input_dir,load_dir,output_dir,file_type)
% The main function of PetSeg
% INPUT:   input_dir   load the PET images to be segmented
%          load_dir    load the mat files
% 		   file_type   such as 'Clinical' 'Phantom' 'Simu' 'Union'
% OUTPUT:  segedmat	 

% examples:
% input_dir='D:\data\PET_liu\send\data\test_input\clinical_3_PET.nii';
% load_dir='D:\data\PET_liu\send\data\trained_model\';
% output_dir='D:\data\PET_liu\send\data\output\';
% file_type='Clinical';

dirname = fileparts(mfilename('fullpath')); % Current directory
addpath(genpath(dirname));  % Add all subdirectory
cd(dirname);

TestImg=load_nii(input_dir);

disp('Get the features of the test sample:');
feat_gray=featextract(TestImg.img,'gray');
feat_texture=featextract(TestImg.img,'texture');

if nargin<3
	error('Need 3 parameters at least!');
elseif nargin<4
    file_type='Union';
end

switch(file_type)
    case 'Clinical'
        load([load_dir 'Model_Gray_Clin.mat']);
        X_tst=feat_gray;        
    case 'Phantom'
        load([load_dir 'Model_Gray_Phantom.mat']);
        X_tst=feat_gray;     
    case 'Simu'
        load([load_dir 'Model_Gray_Simu.mat']);
        X_tst=feat_gray;     
    case 'Union'
        load([load_dir 'Model_Texture_Union.mat']);
        X_tst=feat_texture;
end
disp('Classificating the voxels:');
Y_hat=classRF_predict(X_tst,model);
temp=TestImg;
SegResult=GetSegResult(temp.img,Y_hat);
temp.img=SegResult;

save_nii(temp,[output_dir 'result.nii']);