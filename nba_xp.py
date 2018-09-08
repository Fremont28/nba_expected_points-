import sklearn 
from sklearn.linear_model import Lasso
import pandas as pd 
import numpy as np 

pbp=pd.read_csv("nba_pbp_16.csv")
pbp.info()
pbp.player.value_counts() #steph curry 1936, Klay thompson 1839, Westbrook 1837 

#made, missed encode 
def result_binary(x):
    if x=="made":
        return 1
    else:
        return 0

pbp['result_binary']=pbp['result'].apply(result_binary)
pbp['result_binary'].value_counts()
pbp['assist']=pbp['assist'].astype(str)


def assist_length(x):
    if len(x)>5:
        return 1
    else:
        return 0 

pbp['assist_binary']=pbp['assist'].apply(assist_length)

X=pbp[["shot_distance","assist_binary","converted_x","converted_y"]]
X=X.reshape(-1,1)
y=pbp['points']

X_train,X_test,y_train,y_test=train_test_split(X,y,test_size=0.3)
X_train1=X_train[["shot_distance","assist_binary"]]
X_test1=X_test[["shot_distance","assist_binary"]]
X_coords=X_test[["converted_x","converted_y"]]

#lasso regression--- L1 prior as a regularizer 
lasso=Lasso(alpha=0.2,normalize=False)
lasso_model=lasso.fit(X_train1,y_train)
lasso_predict=lasso.predict(X_test1)
lasso_predict 
lasso_model.coef_
lasso_model.intercept_
lasso_predict1=pd.DataFrame(lasso_predict,columns=['pred_points'])

y_test1=pd.DataFrame(y_test,columns=['points'])
y_test2=y_test2.reset_index(level=0,inplace=True)
merge_results=pd.concat([X_test1,lasso_predict1],axis=1)
merge_results1=merge_results.iloc[:,2:5]
merge_results1.reset_index(drop=True, inplace=True)
X_coords.reset_index(drop=True, inplace=True)
y_test1.reset_index(drop=True, inplace=True)

merge_results2=pd.concat([merge_results1,X_coords],axis=1)
merge_results3=pd.concat([merge_results2,y_test1],axis=1)
merge_results3.to_csv("shot_chart.csv")

#three pointers assists 
three=pbp[(pbp.shot_distance>=23) & (pbp.assist_binary==0)]
three_pct=three.result_binary.value_counts() 