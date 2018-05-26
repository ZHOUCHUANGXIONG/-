clc;
clear;
close all;

% 加载模板库数据（X,Y）
load('X');
load('Y');
X=X';
Y=Y';

%% 待测试的分割字符  读取：
test_path = 'G:\微信\WeChat Files\DTi0113\Files\BigHead\results\test36';
figs = dir(test_path);%子文件夹
test_X=[];
for i=3:length(figs)
    fig_path = fullfile( test_path,figs(i).name);
    bw=imread(fig_path);
    bw = imresize(bw,[18,12]);
    bw = im2bw(bw);
    imshow(bw);
    x = reshape(bw,[18*12,1]); 
    test_X=[test_X,x];       
end
test_X=test_X';


%% 距离计算
predictions = zeros(size(test_X,1),1);
for i=1:size(test_X,1)
    scores = zeros(size(X,1),1);
    for j=1:size(X,1)
       dist = sum((test_X(i,:)-X(j,:)).^2);  %这里用欧式距离
        scores(j,1) = dist;%得分越小，说明越相符，对得越整齐，相减就越小
    end
    [~,ind]=sort(scores);%返回最小的k个的索引
    k=11;
    [~,knn] =  max(histc(Y(ind(1:k)),0:10));%统计这个k个中，哪个数字最多
    predictions(i)=knn-1;
end

%%可视化，利用predictions和原分割的字符对应画图

% % figure;
% subplot(length(figs),1);
for i=3:length(figs)
    fig_path = fullfile( test_path,figs(i).name);
    bw=imread(fig_path);
    bw = imresize(bw,[18,12]);
    subplot(1,length(figs),i-2);
    imshow(bw);
    if predictions(i-2)~=10
        title(num2str(predictions(i-2)));
    else
        title('背景');
    end
%     predictions(i-2)
end




