%This function generates the model for a material type at a particular
%distance. Current restricted 
function model = generateModel(DistModel, Distance) %Dist 1-7
model(1,:,:) = DistModel.blast(Distance,:,:);
model(2,:,:) = DistModel.rust(Distance,:,:);
model(3,:,:) = DistModel.steel(Distance,:,:);
model(4,:,:) = DistModel.timber(Distance,:,:);