clear
imageArray(1).val = 'gradeA.jpg';
imageArray(2).val = 'gradeB.jpg';
imageArray(3).val = 'gradeC.jpg';
imageArray(4).val = 'gradeD.jpg';
segmentation = 2;
%Create the pdf model
model = createGLCMModel(imageArray, segmentation);

%Randomly select X by X patches to test with
pixels = 50; %Determine how big the image is
sampleSize = 10; %Number of random samples 
for curr_material = 1:size(gradeImage,2)
    for curr_sample = 1:sampleSize    
        randRowPos = floor((size(gradeImage(1).val,1)-pixels)*rand);
        randColPos = floor((size(gradeImage(1).val,2)-pixels)*rand);        
        randImage(curr_material,curr_sample) = gradeImage(curr_mat).val(randRowPos:randRowPos+pixels,randColPos:randColPos+pixels,1), 'Offset', offsets, 'NumLevels', 8);
        glcmGradeMatrix(curr_material,curr_sample).G = graycomatrix(gradeImage(curr_mat).val(randRowPos:randRowPos+pixels,randColPos:randColPos+pixels,2), 'Offset', offsets, 'NumLevels', 8);
        glcmGradeMatrix(curr_material,curr_sample).B = graycomatrix(gradeImage(curr_mat).val(randRowPos:randRowPos+pixels,randColPos:randColPos+pixels,3), 'Offset', offsets, 'NumLevels', 8);
        glcmGradeMatrix(curr_material,curr_sample).Gray = graycomatrix(rgb2gray(gradeImage(curr_mat).val(randRowPos:randRowPos+pixels,randColPos:randColPos+pixels,:)), 'Offset', offsets, 'NumLevels', 8);        
    end
end

%Generate a random image
keyboard