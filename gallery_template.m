clc,close all;
clear all;

%% ·����
train_path = 'G:\΢��\WeChat Files\DTi0113\Files\BigHead\results\gallery\�ַ�ģ���';
figs_paths = dir(train_path);%���ļ���

%% �ſ���������ݺͱ�ע
X=[];
Y=[];  %from 0~9, 10=background
%��ͼ��
for i=3:length(figs_paths)
    fig_path = fullfile( train_path,figs_paths(i).name);
    %ͼƬ
    imgs = dir(fig_path);
    for j=3:length(imgs)
        %ͼƬ����
        img = fullfile(fig_path,imgs(j).name);
        rgb=imread(img);
        rgb = imresize(rgb,[18,12]);%��ͼƬͳһ��18*12��С
         rgb = im2bw(rgb);
        % imshow(rgb);
        x = reshape(rgb,[18*12,1]); %��ͼƬ����һ���ߣ���������Ϊ�˷������ͼƬ����
        X=[X,x];
        Y=[Y,i-3];
    end
end

%% ���棨X,Y��
save X X;
save Y Y;

disp('******************************************************');
for i=3:length(figs_paths)
    figs_paths(i).name
end




