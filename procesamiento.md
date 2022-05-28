Dependencias para el procesamiento de los datos.
```python
import pandas as pd
import fastprogress
import time

import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import calendar
```

La lectura de los datos se hace en una carpeta compartida en drive, esta ruta se puede adecuar según el caso.

```python
ruta_datos = '/content/drive/Shareddrives/TAE/Entregas/2/Datos/'
ruta_destino = '/content/drive/Shareddrives/TAE/Entregas/2/'
```

Algunas funciones que se usarán para el procesamiento de los datos.

```python
dict_months = dict((month, index) for index, month in enumerate(calendar.month_abbr) if month)

def convert_grade_to_num(grade):
    return (int(grade[0],17)-10)*5 + int(grade[1],6)-1

def convert_date(date_string):
    global dict_months

    mes, ano = date_string.split('-')
    ano = int(ano)
    if(ano>22):
        ano -= 100
    mes = dict_months[mes]
    return (mes, ano)

def calc_dif_in_month(issue_d, first_d):
    return (issue_d[0] - first_d[0])*12 +  issue_d[1] - first_d[1]
```

Lectura de los datos.
```python
datos = pd.read_csv(ruta_datos + 'loan_data_2007_2014.csv', sep=',')
```


```python
len(datos.columns)
```
Output: 74

Tenemos 74 columnas/variables en el dataset original.
En estas variables se encuentran algunas que no contienen información relevante para nuestro caso, por esto mismo se realizará una preselección de posibles variables predictoras.

# Creación de la variable objetivo

Se considera como *default* a un cliente que tenga alguno de los siguientes valores en la columna loan_status:
- Default
- Late (31-120 days)
- Charged Off
- Does not meet the credit policy. Status: Charged Off

Se construye la variable good_bad, la cual es una variable binaria que se representa como *1* si el cliente está en *default* y *0* en otro caso.

```python
datos['good_bad'] = datos['loan_status'].apply(lambda x: 1
                                               if (x == 'Default' 
                                                   or x == 'Late (31-120 days)' 
                                                   or x == 'Charged Off' 
                                                   or x == 'Does not meet the credit policy. Status:Charged Off')
                                               else 0)
```


```python
datos.good_bad.astype(str).str.get_dummies().sum()
```
Output:
1 - 50968
0 - 415317
dtype: int64

Dada la variable objetivo, tenemos un poco más de 50.000 datos de clientes que se encuentran en *default*.

Estos 29 datos todavía no tienen un cuentas 
```python
datos_sin_earlier_credit = datos.query('earliest_cr_line != earliest_cr_line ', inplace=False)
# datos_sin_earlier_credit = datos.query('delinq_2yrs.isna()', inplace=False)
index_of_nan = datos_sin_earlier_credit.isna().sum()
index_of_nan = list(index_of_nan.index[index_of_nan==29])
datos_para_update = datos_sin_earlier_credit[index_of_nan].copy()
datos_para_update['earliest_cr_line'] = datos_sin_earlier_credit.issue_d

for column in ['inq_last_6mths', 'delinq_2yrs', 'open_acc', 'pub_rec', 'total_acc', 
               'collections_12_mths_ex_med', 'acc_now_delinq', 'tot_coll_amt']:
    datos_para_update[column].replace(np.nan, 0, inplace=True)

datos.update(datos_para_update.rename({'issue_d':'earliest_cr_line'}), overwrite=True)
```

# Acondicionamiento de los datos.

Ahora se realiza un proceso de acondicionamiento con el fin de obtener las columnas como números o como variables binariass según el caso.

```python
datos.mths_since_last_delinq = datos.mths_since_last_delinq.max()+1-datos.mths_since_last_delinq
datos.mths_since_last_delinq.replace(np.nan, 0, inplace=True)
```
Convertimos algunas variables que contienen fechas a una tupla con el formato *(mes, año)*
```python
datos['issue_d'] =  datos.issue_d.apply(convert_date)
datos['earliest_cr_line'] =  datos.earliest_cr_line.apply(convert_date)
```

Se recalculan algunas variables a valores más dicientes numéricamente.
```python
datos['sub_grade'] = datos.sub_grade.apply(convert_grade_to_num)

datos['earliest_cr_line'] = datos.issue_d.combine(datos.earliest_cr_line, calc_dif_in_month)
```
Se pasan algunas variables a números enteros para un fácil manejo de estas.
```python
datos['emp_length'] = pd.to_numeric(datos.emp_length.str.replace('\+ years', '').str.replace('< 1 year', '0').str.replace('years', '').str.replace('year', ''))
datos['verification_status'] = pd.to_numeric(datos.verification_status.str.replace('Source Verified', '2').str.replace('Not Verified', '0').str.replace('Verified', '1'))
```

Se pasan variables con solo dos opciones de respuesta a variables binarias.
```python
datos.initial_list_status = datos.initial_list_status == 'f'
datos.pymnt_plan = datos.pymnt_plan == 'y'
datos.term = datos.term == '60 months'
```


No se tiene suficiente información en las siguientes variables.
Porcentage de NaN-values:
```python
datos.query('mths_since_last_major_derog != mths_since_last_major_derog', 
            inplace=False).loan_status.str.get_dummies().sum()/sum_per_status
```
Output:
Charged Off                                            0.812760
Current                                                0.752237
Default                                                0.742788
Does not meet the credit policy. Status:Charged Off    1.000000
Does not meet the credit policy. Status:Fully Paid     1.000000
Fully Paid                                             0.826431
In Grace Period                                        0.721869
Late (16-30 days)                                      0.692939
Late (31-120 days)                                     0.719130

```python
datos.query('mths_since_last_record != mths_since_last_record', 
            inplace=False).loan_status.str.get_dummies().sum()/sum_per_status
```
Output:
Charged Off                                            0.879435
Current                                                0.851761
Default                                                0.830529
Does not meet the credit policy. Status:Charged Off    0.613666
Does not meet the credit policy. Status:Fully Paid     0.715292
Fully Paid                                             0.883490
In Grace Period                                        0.856961
Late (16-30 days)                                      0.831691
Late (31-120 days)                                     0.840870


Se eliminan variables con poca información, información inútil o información que no podemos obtener de un cliente que aún no tenga contrato con la entidad.
```python
# sin informacion útil:
datos.drop(['loan_status', 'url', 'id', 'member_id', 'title', 'desc', 'emp_title', 
            'sub_grade', 'zip_code', 'issue_d', 'collections_12_mths_ex_med', 
            'acc_now_delinq', 'pymnt_plan', 'term'], axis=1, inplace=True)

# con Nan
datos.drop(['mths_since_last_major_derog', 'mths_since_last_record', 'tot_coll_amt',
            'tot_cur_bal', 'total_rev_hi_lim'], axis=1, inplace=True)

# variables que no existen antes del contrato
datos.drop(['out_prncp', 'out_prncp_inv', 'total_pymnt', 'total_pymnt_inv', 'total_rec_prncp',
            'total_rec_int', 'total_rec_late_fee', 'last_credit_pull_d', 'recoveries',
            'collection_recovery_fee','last_pymnt_d', 'last_pymnt_amnt', 'revol_bal',
            'revol_util', 'next_pymnt_d'], axis=1, inplace=True)
```

Estas son las variables resultantes:
```python
datos.columns
```
Output:
Index(['loan_amnt', 'funded_amnt', 'funded_amnt_inv', 'int_rate',
       'installment', 'grade', 'emp_length', 'home_ownership', 'annual_inc',
       'verification_status', 'purpose', 'addr_state', 'dti', 'delinq_2yrs',
       'earliest_cr_line', 'inq_last_6mths', 'mths_since_last_delinq',
       'open_acc', 'pub_rec', 'total_acc', 'initial_list_status', 'good_bad'],
      dtype='object')


Para los siguientes valores tenemos datos faltantes:
```python
missing_data = datos.isna().sum()
missing_data = missing_data[missing_data != 0]
missing_data = missing_data.to_frame()
missing_data.columns = ["Qty"]
missing_data["Missing data (%)"] = missing_data["Qty"]/datos.shape[0]*100
missing_data
```
Output:
	Qty	Missing data (%)
emp_length	21008	4.505399
annual_inc	4	0.000858


Se remplazan dichos datos faltantes por lo siguiente:

- *emp_length*: Se hace la supocisión de que la duración del empleo para estos casos es de 0 años.
- *annual_inc*: Se reemplazará por la media.


```python
datos.emp_length.fillna(0, inplace=True)
datos.annual_inc.fillna(datos.annual_inc.mean(), inplace=True)
```

Para terminar, se exportan los datos luego del proprocesamiento en la ruta indicada y en formato *feather* pues reduce notablemente el peso del archivo sin perder información.
```python
datos.to_feather(ruta_destino + 'datos_juntos.feather')
```
