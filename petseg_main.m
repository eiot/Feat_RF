function SegResult = petseg_main(input_dir,load_dir,output_dir)
% The main function of PetSeg
% INPUT:   input_dir   load the PET images to be segmented
%          load_dir    load the mat files
% OUTPUT:  segedmat	 
%
% The files in input_dir are supposed to be the same directory with  PETSEG - Training data, such as:
% input_dir
% ├─Clinical
% │  ├─clinical_1
% │  ├─clinical_2
% │  └─clinical_3
% ├─Phantom
% │  ├─phantom_1
% │  ├─phantom_2
% │  └─phantom_3
% └─Simu
%    ├─Simu_1
%    └─Simu_2
%
% examples(Window):
% input_dir='D:\data\PET_liu\send_new\Feat_RF\data\test_input\';
% load_dir='D:\data\PET_liu\send_new\Feat_RF\data\trained_model\';
% output_dir='D:\data\PET_liu\send_new\Feat_RF\data\output\';
%
% examples(Linux):
% input_dir='/mysoft/PET_liu/Feat_RF-master/data/test_input/';
% load_dir='/mysoft/PET_liu/Feat_RF-master/data/trained_model/';
% output_dir='/mysoft/PET_liu/Feat_RF-master/data/output/';

if strcmpi(computer,'PCWIN') |strcmpi(computer,'PCWIN64')
   file_slash='\';
else
   file_slash='/';
end
dirname = fileparts(mfilename('fullpath')); % Current directory
addpath(genpath(dirname));  % Add all subdirectory
cd(dirname);

cd(input_dir); 
all_list=[dir('c*');dir('p*');dir('s*')];

for i=1:size(all_list,1)

    file_type=all_list(i).name;
    cd([input_dir file_type file_slash]);
    type_list=dir(['*',file_type(2:end),'*']);
    for j=1:size(type_list,1)
        pat_folder=type_list(j).name;
        cd([input_dir file_type file_slash pat_folder file_slash]);
        nii_list=dir('*.nii');
        for k=1:size(nii_list,1)
            original_file=[input_dir file_type file_slash pat_folder file_slash nii_list(k).name];
            TestImg=load_nii(original_file);
            %disp('Get the features of the test sample:');
            feat_gray=featextract(TestImg.img,'gray');
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
            end
            %disp('Classificating the voxels:');
            Y_hat=classRF_predict(X_tst,model);
            temp=TestImg;
            SegResult=GetSegResult(temp.img,Y_hat);
            temp.img=SegResult;
            
            seged_dir=[output_dir file_slash file_type file_slash pat_folder];
            if ~(exist(seged_dir, 'dir') )        mkdir(seged_dir);  end
            
            save_nii(temp,[seged_dir file_slash 'Result_' nii_list(k).name(1:end-4) '.nii']);
        end        
    end
end