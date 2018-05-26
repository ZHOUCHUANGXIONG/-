clc,close all;
clear all;


%��һ������ͼ*******************************************************************************************************
%%·��
% raw_img_path = 'G:\r1.jpg';

%% ����ȡ��·��
% raw_img_path = 'G:\test\test15.jpg';
% relative_path='test15';
% save_path=['results/gallery/' relative_path '/'];

raw_img_path = 'G:\test36.jpg';
relative_path='test36';
save_path=['results/' relative_path '/'];



%�ڶ�������ע��ɫ����Ϊ1*******************************************************************************************
%%ǰ������ɫ
color1 = [0,0,255]; %blue
color2 = [255,255,255]; %white
threshold1 = 0.25;
threshold2 = 0.2;
rgb=imread(raw_img_path);
rgb = imresize(rgb,0.1);
figure;imshow(rgb);title('��ɫͼ');
logistic1  = extract_color( rgb,color1,threshold1 );
logistic2 = extract_color( rgb,color2,threshold2 );

% logistic1=1-logistic1;
logistic2=1-logistic2;
% logistic=logistic1+logistic2;
logistic=logistic1&logistic2;%���ߵ�����

figure;imshow(logistic1);title('��ɫǰ����ע');
figure;imshow(logistic2);title('��ɫǰ����ע');
figure;imshow(logistic);title('ǰ����ע');

%���������ҵ���ֱ�ָ���**************************************************************************************
%==================
%��ֱ�߷ָ�, vertical
%%ͳ�ƺ�ƽ����I4�Ǵ�ֱͳ�Ƹ�����ֱ��ͼ
 I4=sum(logistic,1)/size(logistic,1);
figure;
plot(1:size(logistic,2),I4);
hold on;

%%��3��ƽ����ƽ��������Ŀ���Ƿ�ֹ�������ţ���һ���棬���ĵ��ܵ��ܶ�����Ӱ�죬�����ܴ�
h=[1,1,1];
y=conv(I4,h);
y=conv(y,h);
y=conv(y,h);

plot(1:size(y,2),y,'r');
hold on;
title('��ֱͳ��');
%%��������ֱ�ߣ�vertical_lines
mid_point_min = max(y)/3;
vertical_lines= find(y-mid_point_min>0);
%%����������
mid_point_index = floor((min(vertical_lines)+max(vertical_lines))/2);

%%���ӻ�����������
plot(1:mid_point_index,y(1:mid_point_index),'g');


%%�����ұߣ������ߣ�
correct_pixel=5;
I4_min_point_interval = I4(mid_point_index-correct_pixel:mid_point_index+correct_pixel);
[~,mid_point_index_thelta ]= min(I4_min_point_interval);
mid_point_index_correct = mid_point_index-correct_pixel+mid_point_index_thelta-1;

%%�������
left_point_index = min(vertical_lines);
I4_left_min_point_interval = I4(left_point_index-correct_pixel:left_point_index+correct_pixel);
[~,left_point_index_thelta ]= min(I4_left_min_point_interval);
I4_left_min_point_interval_correct = left_point_index-correct_pixel+left_point_index_thelta-1;

%%ȥ����ߺ��ұߺڿ飬����complement_pixel�ǲ������أ�����Ҫ���������ⲽ��
complement_pixel=2;
remove_index = [1:I4_left_min_point_interval_correct+complement_pixel,mid_point_index_correct-complement_pixel:size(logistic,2)];

logistic(:,remove_index) = [];
figure;imshow(logistic);
title('��ֱ�ָ��');
%==================

%���Ĳ����ҵ�ˮƽ�ָ���**************************************************************************************
%==================
%%ˮƽ�߷ָ�, horizontal line
 I3=sum(logistic,2)/size(logistic,2);%ˮƽͳ��
figure; plot(1:size(logistic,1),I3);
title('ˮƽͳ��');

pro_horizontal_lines = find( I3==0);%��ˮƽ���϶��Ǻ����ص��ߣ�find����ֵ������ֵ

figure;imshow(logistic);
 hold on;


% pro_horizontal_lines = find( I3==0);
%%������ʵ��������������5�Ĳ���Ϊ�Ƿָ���
y_interval_min = 5;
h=[1,-1];
horizontal_interval=conv(pro_horizontal_lines,h);
horizontal_lines=pro_horizontal_lines(horizontal_interval>y_interval_min);

horizontal_lines=[horizontal_lines;size(logistic,1)];%ʵ���ϼ������һ���ָ���
for i=1:length(horizontal_lines)
    plot([1,length(I3)],[horizontal_lines(i),horizontal_lines(i)],'LineWidth',2,'Color',[0 1.0 0]);
    hold on;
end
title('ˮƽ�ָ���ӻ�');

%���Ĳ����ָ���ͼ������**************************************************************************************
%%����ָ�ӷָ���������Ϊ��һ�������ܵ����֡�
%�ж��ļ����Ƿ����
if ~exist(save_path)
    mkdir(save_path);
end

%%����
for i=2:length(horizontal_lines)
    seg_figures = logistic(horizontal_lines(i-1):horizontal_lines(i),:);
    img_name = strcat(save_path,relative_path,'_',num2str(i-1,'%03d'),'.jpg');
    imwrite(seg_figures,img_name);
end










