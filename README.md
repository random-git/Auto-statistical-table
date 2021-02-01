# Auto-statistical-table
[stat_tab.R](https://github.com/random-git/Auto-statistical-table/blob/main/stat_tab.R) generates formatted descriptive statistical tables of the dataset in batch.


### Example of input data ([testdf.xlsx](https://github.com/random-git/Auto-statistical-table/blob/main/testdf.xlsx)) is shown as below:
![input_tb](https://user-images.githubusercontent.com/62033407/106522744-bf7db480-64a5-11eb-81dc-5d2f313071fd.png)

### Demo
#### Enter list of varialbes for subgroup comparisons:
```ruby
var_list = c("var8","var9","var10","var11")
```
#### Call the function:
```ruby
dec_tab(var_list)
```
summary of continous variables will be saved as [continous_summary.xlsx](https://github.com/random-git/Auto-statistical-table/blob/main/continous_summary.xlsx) and categorical variables as [categorical_summary.xlsx](https://github.com/random-git/Auto-statistical-table/blob/main/categorical_summary.xlsx). Sample outputs are shown as:<br/>
![cont_tb](https://user-images.githubusercontent.com/62033407/106523155-50ed2680-64a6-11eb-849e-c13986ecc096.png)
![cat_tb](https://user-images.githubusercontent.com/62033407/106523204-5ea2ac00-64a6-11eb-9cd6-0df516da78e5.png)

