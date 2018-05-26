clc;
clear;
close all;

% ����ģ������ݣ�X,Y��
load('X');
load('Y');
X=X';
Y=Y';

%% �����Եķָ��ַ�  ��ȡ��
test_path = 'G:\΢��\WeChat Files\DTi0113\Files\BigHead\results\test36';
figs = dir(test_path);%���ļ���
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


%% �������
predictions = zeros(size(test_X,1),1);
for i=1:size(test_X,1)
    scores = zeros(size(X,1),1);
    for j=1:size(X,1)
       dist = sum((test_X(i,:)-X(j,:)).^2);  %������ŷʽ����
        scores(j,1) = dist;%�÷�ԽС��˵��Խ������Ե�Խ���룬�����ԽС
    end
    [~,ind]=sort(scores);%������С��k��������
    k=11;
    [~,knn] =  max(histc(Y(ind(1:k)),0:10));%ͳ�����k���У��ĸ��������
    predictions(i)=knn-1;
end

%%���ӻ�������predictions��ԭ�ָ���ַ���Ӧ��ͼ

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
        title('����');
    end
%     predictions(i-2)
end




