load fisheriris
X = meas;
Y = species;
t = templateSVM('Standardize',1);
Mdl = fitcecoc(X,Y,'Learners',t,'ClassNames',{'setosa','versicolor','virginica'});
CVMdl = crossval(Mdl);
oosLoss = kfoldLoss(CVMdl);

idx = randsample(size(X,1),10,1);
Mdl.ClassNames
table(Y(idx),label(idx),Posterior(idx,:),...
    'VariableNames',{'TrueLabel','PredLabel','Posterior'})