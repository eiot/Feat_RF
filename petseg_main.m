function SegResult = petseg_run_new(input_dir,load_dir,output_dir)
% The main function of PetSeg
% INPUT:   input_dir   load the PET images to be segmented
%          load_dir    load the mat files
% OUTPUT:  segedmat	 

% examples:
% input_dir='D:\data\PET_liu\send\data\test_input\';
% load_dir='D:\data\PET_liu\send\data\trained_model\';
% output_dir='D:\data\PET_liu\send\data\output\';


dirname = fileparts(mfilename('fullpath')); % Current directory
addpath(genpath(dirname));  % Add all subdirectory
cd(dirname);

cd(input_dir); 
all_list=[dir('C*');dir('P*');dir('S*')];

for i=1:3
    file_type=all_list(i).name;
    cd([input_dir file_type '\']);
    type_list=dir(['*',file_type(2:end),'*']);
    for j=1:size(type_list,1)
        pat_folder=type_list(j).name;
        cd([input_dir file_type '\' pat_folder '\']);
        nii_list=dir('*.nii');
        for k=1:size(nii_list,1)
            original_file=[input_dir file_type '\' pat_folder '\' nii_list(k).name];
            TestImg=load_nii(original_file);
            disp('Get the features of the test sample:');
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
            disp('Classificating the voxels:');
            Y_hat=classRF_predict(X_tst,model);
            temp=TestImg;
            SegResult=GetSegResult(temp.img,Y_hat);
            temp.img=SegResult;
            
            seged_dir=[output_dir '\' file_type '\' pat_folder];
            if ~(exist(seged_dir, 'dir') )        mkdir(seged_dir);  end
            
            save_nii(temp,[seged_dir '\Result_' nii_list(k).name(1:end-4) '.nii']);
        end        
    end
end




