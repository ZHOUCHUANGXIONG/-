function [ logistic ] = extract_color( image,color,threshold )
%EXTRACT_COLOR �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
[r,c,chanel]=size(image);
image=im2double(image);
color=color/255;
threshold=threshold*3;%������ɫ�������������ô���ˣ�
image_temp=zeros(size(image));
for i=1:r
    for j=1:c
%         temp=squeeze(image(i,j,:));
%         image(i,j,:)=temp-color';
          image_temp(i,j,:)=color';
    end
end

% for i=1:r
%    image(i,:,:)=bsxfun(@minus,image(i,:,:),color);
% end
%figure,
%imshow(image_temp);
image=image-image_temp;
image=image.*image;
gray=sum(image,3);
logistic=gray<threshold.*threshold;%����1����������Ǹ���ɫ����ʾ��ɫ��
end

