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

%% fix annotation to match information from website

tableName = [ pwd '/ParcellationLausanne2008_left.csv' ] ;
lh_table = readtable(tableName,'ReadVariableNames',1);

tableName = [ pwd '/ParcellationLausanne2008_right.csv' ] ;
rh_table = readtable(tableName,'ReadVariableNames',1);

%% left hemi

lh_target_lab_name = [ 'scale' scale 'labels' ] ;
lh_target_lab = lh_table.(lh_target_lab_name) ;

% rearrange the structs we got by the ordering in the target
lh_reorder = zeros(length(lh_temp_ct.struct_names),1) ;
lh_reorder(1) = 1 ;

for idx = 1:length(lh_target_lab)
    
    disp(lh_target_lab(idx))
    
    tmp = cellfun(@(x) strcmp(strtrim(lh_temp_ct.struct_names),strtrim(x)) , lh_target_lab(idx), 'UniformOutput',0) ;
    tmp_ind = find(cell2mat(tmp) == 1) ;
    
    if sum(cell2mat(tmp)) == 0
        disp('not found')
        lh_reorder(idx) = -1 ;
        continue
    end
    
    lh_reorder(idx) = tmp_ind ;
    
end

lh_reorder(lh_reorder == -1) = [] ;
lh_reorder = [ 1 ; lh_reorder ] ;

%% right hemi

rh_target_lab_name = [ 'scale' scale 'labels' ] ;
rh_target_lab = rh_table.(rh_target_lab_name) ;

% rearrange the structs we got by the ordering in the target
rh_reorder = zeros(length(rh_temp_ct.struct_names),1) ;

for idx = 1:length(rh_target_lab)
    
    disp(rh_target_lab(idx))
    
    tmp = cellfun(@(x) strcmp(strtrim(rh_temp_ct.struct_names),strtrim(x)) , rh_target_lab(idx), 'UniformOutput',0) ;
    tmp_ind = find(cell2mat(tmp) == 1) ;
    
    if sum(cell2mat(tmp)) == 0
        disp('not found')
        rh_reorder(idx) = -1 ;
        continue
    end
    
    rh_reorder(idx) = tmp_ind ;
    
end

rh_reorder(rh_reorder == -1) = [] ;
rh_reorder = [ 1 ; rh_reorder ] ;

%% assign vals

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

new_lh_temp_ct = lh_temp_ct ;
new_rh_temp_ct = rh_temp_ct ;

new_lh_temp_ct.struct_names = lh_temp_ct.struct_names(lh_reorder) ;
new_rh_temp_ct.struct_names = rh_temp_ct.struct_names(rh_reorder) ;

new_lh_temp_ct.table = lh_temp_ct.table(lh_reorder,:) ;
new_rh_temp_ct.table = rh_temp_ct.table(rh_reorder,:) ;

new_lh_temp_ct.numEntries = size(new_lh_temp_ct.table,1) ;
new_rh_temp_ct.numEntries = size(new_rh_temp_ct.table,1) ;

write_annotation(lh_annot_name,lh_temp_vert,lh_lab_mode,new_lh_temp_ct)
write_annotation(rh_annot_name,rh_temp_vert,rh_lab_mode,new_rh_temp_ct)





