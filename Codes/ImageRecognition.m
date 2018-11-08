%主函数
function ImageRecognition()
clc
clear
cutimage= imread('eg.jpg');

cutimage = rgb2hsv(cutimage);

img = cutimage(:,:,1);
cluster_num = 2;    % 设置分类数
maxiter = 60;       % 最大迭代次数

%-------------随机初始化标签----------------
%label = randi([1,cluster_num],size(img));

%-----------kmeans最为初始化预分割----------
label = kmeans(img(:),cluster_num);
label = reshape(label,size(img));
iter = 0;

while iter < maxiter
    %-------计算先验概率---------------
    %这里我采用的是像素点和3*3领域的标签相同
    %与否来作为计算概率
    %------收集上下左右斜等八个方向的标签--------
    label_u = imfilter(label,[0,1,0;0,0,0;0,0,0],'replicate');
    label_d = imfilter(label,[0,0,0;0,0,0;0,1,0],'replicate');
    label_l = imfilter(label,[0,0,0;1,0,0;0,0,0],'replicate');
    label_r = imfilter(label,[0,0,0;0,0,1;0,0,0],'replicate');
    label_ul = imfilter(label,[1,0,0;0,0,0;0,0,0],'replicate');
    label_ur = imfilter(label,[0,0,1;0,0,0;0,0,0],'replicate');
    label_dl = imfilter(label,[0,0,0;0,0,0;1,0,0],'replicate');
    label_dr = imfilter(label,[0,0,0;0,0,0;0,0,1],'replicate');
    p_c = zeros(cluster_num,size(label,1)*size(label,2));
    % 计算像素点8领域标签相对于每一类的相同个数
    for i = 1:cluster_num
        label_i = i * ones(size(label));
        temp = ~(label_i - label_u) + ~(label_i - label_d) + ...
            ~(label_i - label_l) + ~(label_i - label_r) + ...
            ~(label_i - label_ul) + ~(label_i - label_ur) + ...
            ~(label_i - label_dl) +~(label_i - label_dr);
        p_c(i,:) = temp(:)/8;%计算概率
    end
    p_c(p_c == 0) = 0.001;%防止出现0
    %---------------计算似然函数----------------
    mu = zeros(1,cluster_num);
    sigma = zeros(1,cluster_num);
    %求出每一类的的高斯参数--均值方差
    for i = 1:cluster_num
        index = label == i;%找到每一类的点
        data_c = double(img(index));
        mu(i) = mean(data_c);%均值
        sigma(i) = var(data_c);%方差
    end
    p_sc = zeros(cluster_num,size(label,1)*size(label,2));
%     for i = 1:size(img,1)*size(img,2)
%         for j = 1:cluster_num
%             p_sc(j,i) = 1/sqrt(2*pi*sigma(j))*...
%               exp(-(img(i)-mu(j))^2/2/sigma(j));
%         end
%     end
    %------计算每个像素点属于每一类的似然概率--------
    %------为了加速运算，将循环改为矩阵一起操作--------
    for j = 1:cluster_num
        MU = repmat(mu(j),size(img,1)*size(img,2),1);
        p_sc(j,:) = 1/sqrt(2*pi*sigma(j))*...
            exp(-(double(img(:))-MU).^2/2/sigma(j));
    end 
    %找到联合一起的最大概率最为标签，取对数防止值太小
    [~,label] = max(log(p_c) + log(p_sc));
    %改大小便于显示
    label = reshape(label,size(img));
    iter = iter + 1;
end

m = numel(label);
x = length(find(label==1));
y = min(x,m-x);

% Roberts算子
% BW1 = edge(label,'Roberts',0.04);
% g1 = length(find(BW1==1))/2;
% h1 = y/g1;

% Sobel算子
% BW2 = edge(label,'Sobel',0.04);
% g2 = length(find(BW2==1))/2;
% h2 = y/g2;

% Prewitt算子
BW3 = edge(label,'Prewitt',0.04);
g3 = length(find(BW3==1))/2;
h3 = y/g3;


% LOG算子
% BW4 = edge(label,'LOG',0.004);
% g4 = length(find(BW4==1))/2;
% h4 = y/g4;

% Canny算子
% BW5 = edge(label,'Canny',0.04);
% g5 = length(find(BW5==1))/2;
% h5 = y/g5;

% Sobel算子
% BW6 = edge(label,'Sobel',0.04);
% g6 = length(find(BW6==1))/2;
% h6 = y/g6

% 显示
global hh1 hh2 hh3;

str = ['测量血管宽度：',num2str(h3),'像素'];

hh1 = subplot(2,2,[1,2]);
imshow(cutimage)
title({str;'截取后图片'})

hh2 = subplot(2,2,3);
imshow(label,[])
title('分割后图像')

hh3 = subplot(2,2,4);
imshow(BW3)
title(' 边缘检测 ')
end