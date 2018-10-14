trees= imread('CLRIS012.jpg');
srgb2lab=makecform('srgb2lab');
lab2srgb=makecform('lab2srgb');
trees_lab=applycform(trees,srgb2lab);
max=100;
L=trees_lab(:,:,1)/max;

trees_imadjust=trees_lab;
trees_lab(:,:,1)=imadjust(L)*max;
trees_imadjust=applycform(trees_imadjust,lab2srgb);

trees_histeq=trees_lab;
trees_histeq(:,:,1)=histeq(L)*max;
trees_histeq=applycform(trees_histeq,lab2srgb);

trees_adapthisteq=trees_lab;
trees_adapthisteq(:,:,1)=adapthisteq(L)*max;
trees_adapthisteq=applycform(trees_adapthisteq,lab2srgb);

figure;subplot(221)
imshow(trees);
title('Original');subplot(222),
imshow(trees_imadjust);
title('imadjust');subplot(223),
imshow(trees_histeq);
title('histeq');subplot(224),
imshow(trees_adapthisteq);
title('adapthisteq');