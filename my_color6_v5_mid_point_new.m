clc,close all;
clear all;


%第一步：读图*******************************************************************************************************
%%路径
% raw_img_path = 'G:\r1.jpg';

%% 库提取的路径
% raw_img_path = 'G:\test\test15.jpg';
% relative_path='test15';
% save_path=['results/gallery/' relative_path '/'];

raw_img_path = 'G:\test36.jpg';
relative_path='test36';
save_path=['results/' relative_path '/'];



%第二步：标注蓝色部分为1*******************************************************************************************
%%前景的颜色
color1 = [0,0,255]; %blue
color2 = [255,255,255]; %white
threshold1 = 0.25;
threshold2 = 0.2;
rgb=imread(raw_img_path);
rgb = imresize(rgb,0.1);
figure;imshow(rgb);title('彩色图');
logistic1  = extract_color( rgb,color1,threshold1 );
logistic2 = extract_color( rgb,color2,threshold2 );

% logistic1=1-logistic1;
logistic2=1-logistic2;
% logistic=logistic1+logistic2;
logistic=logistic1&logistic2;%两者叠起来

figure;imshow(logistic1);title('蓝色前景标注');
figure;imshow(logistic2);title('白色前景标注');
figure;imshow(logistic);title('前景标注');

%第三步：找到垂直分割线**************************************************************************************
%==================
%垂直线分割, vertical
%%统计和平滑，I4是垂直统计个数的直方图
 I4=sum(logistic,1)/size(logistic,1);
figure;
plot(1:size(logistic,2),I4);
hold on;

%%做3次平滑（平均处理），目的是防止噪声干扰，另一方面，中心点受到很多因素影响，波动很大
h=[1,1,1];
y=conv(I4,h);
y=conv(y,h);
y=conv(y,h);

plot(1:size(y,2),y,'r');
hold on;
title('垂直统计');
%%找两条垂直线：vertical_lines
mid_point_min = max(y)/3;
vertical_lines= find(y-mid_point_min>0);
%%估算中心线
mid_point_index = floor((min(vertical_lines)+max(vertical_lines))/2);

%%可视化初步中心线
plot(1:mid_point_index,y(1:mid_point_index),'g');


%%修正右边（中心线）
correct_pixel=5;
I4_min_point_interval = I4(mid_point_index-correct_pixel:mid_point_index+correct_pixel);
[~,mid_point_index_thelta ]= min(I4_min_point_interval);
mid_point_index_correct = mid_point_index-correct_pixel+mid_point_index_thelta-1;

%%修正左边
left_point_index = min(vertical_lines);
I4_left_min_point_interval = I4(left_point_index-correct_pixel:left_point_index+correct_pixel);
[~,left_point_index_thelta ]= min(I4_left_min_point_interval);
I4_left_min_point_interval_correct = left_point_index-correct_pixel+left_point_index_thelta-1;

%%去除左边和右边黑块，其中complement_pixel是补偿像素（不需要在论文提这步）
complement_pixel=2;
remove_index = [1:I4_left_min_point_interval_correct+complement_pixel,mid_point_index_correct-complement_pixel:size(logistic,2)];

logistic(:,remove_index) = [];
figure;imshow(logistic);
title('垂直分割后');
%==================

%第四步：找到水平分割线**************************************************************************************
%==================
%%水平线分割, horizontal line
 I3=sum(logistic,2)/size(logistic,2);%水平统计
figure; plot(1:size(logistic,1),I3);
title('水平统计');

pro_horizontal_lines = find( I3==0);%找水平线上都是黑像素的线，find返回值是坐标值

figure;imshow(logistic);
 hold on;


% pro_horizontal_lines = find( I3==0);
%%这里卷积实际是做差，间隔大于5的才认为是分割线
y_interval_min = 5;
h=[1,-1];
horizontal_interval=conv(pro_horizontal_lines,h);
horizontal_lines=pro_horizontal_lines(horizontal_interval>y_interval_min);

horizontal_lines=[horizontal_lines;size(logistic,1)];%实际上加最底下一根分割线
for i=1:length(horizontal_lines)
    plot([1,length(I3)],[horizontal_lines(i),horizontal_lines(i)],'LineWidth',2,'Color',[0 1.0 0]);
    hold on;
end
title('水平分割可视化');

%第四步：分割子图并保存**************************************************************************************
%%保存分割：从分割线往上认为是一个“可能的数字”
%判断文件件是否存在
if ~exist(save_path)
    mkdir(save_path);
end

%%保存
for i=2:length(horizontal_lines)
    seg_figures = logistic(horizontal_lines(i-1):horizontal_lines(i),:);
    img_name = strcat(save_path,relative_path,'_',num2str(i-1,'%03d'),'.jpg');
    imwrite(seg_figures,img_name);
end










