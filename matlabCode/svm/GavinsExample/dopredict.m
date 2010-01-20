function data_array=dopredict(data_array,model)
guess_data=ones([size(data_array,1),1]);

%1 vers 2
answer(1,2).val=(svmpredict(guess_data,data_array,model(1,2).val)+1)/2;       
%1 vers 3
answer(1,3).val=(svmpredict(guess_data,data_array,model(1,3).val)+1)/2;

%if (1) has already WON then don't try and predict for it do the rest
%2 vers 3
index_of_interest=(answer(1,2).val==1 | answer(1,3).val==1);
answer(2,3).val=zeros([size(answer(1,3).val,1),1]);
answer(2,3).val(index_of_interest)=...
    (svmpredict(guess_data(index_of_interest),...
                data_array(index_of_interest),model(2,3).val)+1)/2;         

            
%make a new image out of data_array
data_array(:,:)=0;
data_array(answer(1,2).val==0 & answer(1,3).val==0,1)=1;
data_array(answer(1,2).val==1 & answer(2,3).val==0,2)=1;
data_array(answer(1,3).val==1 & answer(2,3).val==1,3)=1;

data_array=double(data_array);
end