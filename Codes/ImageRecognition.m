%Ö÷º¯Êý
function diameter = ImageRecognition(imageName)
    diameter = 0;
    
    image = imread(imageName);
    
    
    FunctionAboutHistogram(image);
    
    FunctionAboutDoubleGaussian(image);
end