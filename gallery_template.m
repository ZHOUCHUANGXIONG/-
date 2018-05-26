clc,close all;
clear all;

%% 路径：
train_path = 'G:\微信\WeChat Files\DTi0113\Files\BigHead\results\gallery\字符模板库';
figs_paths = dir(train_path);%子文件夹

%% 放库里面的数据和标注
X=[];
Y=[];  %from 0~9, 10=background
%读图：
for i=3:length(figs_paths)
    fig_path = fullfile( train_path,figs_paths(i).name);
    %图片
    imgs = dir(fig_path);
    for j=3:length(imgs)
        %图片处理
        img = fullfile(fig_path,imgs(j).name);
        rgb=imread(img);
        rgb = imresize(rgb,[18,12]);%把图片统一到18*12大小
         rgb = im2bw(rgb);
        % imshow(rgb);
        x = reshape(rgb,[18*12,1]); %把图片拉成一条线（向量），为了方便后面图片做差
        X=[X,x];
        Y=[Y,i-3];
    end
end

%% 保存（X,Y）
save X X;
save Y Y;

disp('******************************************************');
for i=3:length(figs_paths)
    figs_paths(i).name
end




