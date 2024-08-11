import pandas as pd
import json

# 将excel的数据存在json文件中
df = pd.read_excel('dataset/testdata_target/ZernikeA_testAll.xlsx', sheet_name='Sheet1', header=None)
#
arrays = []
for index, row in df.iterrows():
    array = list(row)
    arrays.append(array)
#
with open('dataset/testdata_target/ZernikeA_testAllJson.json', 'w') as f:
    json.dump(arrays, f)


# 读取json文件
# with open('数据集/训练集target/ZernikeA_trainAllJson.json', 'r') as f:
#     data = json.load(f)
# print(type(data), len(data), sep='\n')
# print(data[0], data[0][0], sep='\n')

