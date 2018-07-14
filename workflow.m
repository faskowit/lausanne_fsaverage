%% 

addpath(genpath('/home/jfaskowi/JOSHSTUFF/software/FS_6p0/freesurfer/matlab/')) 

scale = '250' ;

%% first get the names  of the files I want

lh_baseDir = [ pwd '/data/lh*' scale '*annot' ] ;
lh_files = dir(lh_baseDir) ;

rh_baseDir = [ pwd '/data/rh*' scale '*annot' ] ;
rh_files = dir(rh_baseDir) ;

lh_filenames = cell(length(lh_files),1) ;
rh_filenames = cell(length(rh_files),1) ;

%% read

% function [vertices, label, colortable] = read_annotation(filename, varargin)
% read one file to get started here
[ lh_temp_vert , lh_temp_lab , lh_temp_ct ] = read_annotation([lh_files(1).folder '/' lh_files(1).name]) ;
[ rh_temp_vert , rh_temp_lab , rh_temp_ct ] = read_annotation([rh_files(1).folder '/' rh_files(1).name]) ;

lh_lab_data = zeros(length(lh_temp_lab),101) ;
rh_lab_data = zeros(length(rh_temp_lab),101) ;

% LH
for idx = 1:length(lh_files) 
    
    disp(idx)
    tmp_file = [lh_files(idx).folder '/' lh_files(idx).name] ;
    [~,lh_lab_data(:,idx)] = read_annotation(tmp_file) ;
    
end

% RH
for idx = 1:length(rh_files) 
    
    disp(idx)
    tmp_file = [rh_files(idx).folder '/' rh_files(idx).name] ;
    [~,rh_lab_data(:,idx)] = read_annotation(tmp_file) ;
       
end

%% get majority

lh_lab_mode = mode(lh_lab_data,2) ;
rh_lab_mode = mode(rh_lab_data,2) ;

%% write out annotation 

% function write_annotation(filename, vertices, label, ct)

lh_annot_name = [pwd '/lh.myatlas' scale '.annot' ] ;
rh_annot_name = [pwd '/rh.myatlas' scale '.annot' ] ;

write_annotation(lh_annot_name,lh_temp_vert,lh_lab_mode,lh_temp_ct)
write_annotation(rh_annot_name,rh_temp_vert,rh_lab_mode,rh_temp_ct)





