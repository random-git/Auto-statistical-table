#author:Cong Zhu
#Generate formatted descriptive statistical tables of the dataset in batch
library(readxl)
#load data
#change the working directory as necessary
setwd("...")

df_test = read_excel("testdf.xlsx")


dec_tab = function(var_list){
  dec_sum_list = list()
  n_var = dim(df_test)[2]
  chratable_cluster = list()
  
  cont_index = c()
  cat_index = c()
  

  for (k in c(1:dim(df_test)[2])){
    if (length(table(df_test[[k]]))>5){
      cont_index = append(cont_index, k)
    } 
    else{
      cat_index = append(cat_index, k)
    }
    
  }
  
  #summary statistics of categorical variables
  char_sum_list = list()
  for (var_i in var_list){
    chartable = c()
    var_i_loc = grep(var_i, colnames(df_test))
    cat_index2 = cat_index[!cat_index %in% var_i_loc] 
    for (i in cat_index2){

      tb = table(df_test[[i]], df_test[[var_i]])
      prop.tb = prop.table(tb,2)
      
      p = round(chisq.test(tb)$p.value,3)
      p = ifelse(p<=0.001, "<0.001",p)
      
      P_value = rep("", dim(tb)[1])
      P_value[1] = p
      
      result_list = list()
      for (j in c(1:dim(tb)[2])){
        col = paste("col",1)
        assign(col, paste(tb[,j],"(", round(prop.tb[,j],3)*100,"%",")"))
        result_list[[j]] = eval(as.name(col))
        
        result_temp = do.call(cbind,result_list)
        
        
        
        
        
      }
      
      tab_row_name = paste(names(df_test)[i],":",levels(as.factor(df_test[[i]])))
      tab_col_name = names(table(df_test[[var_i]]))
      
      
      result_temp = as.data.frame(result_temp)
      names(result_temp) = tab_col_name
      row.names(result_temp) = tab_row_name
      
      chartable = rbind(chartable,cbind(result_temp,P_value))
      
      
    }
    char_sum_list = append(char_sum_list, list(as.data.frame(chartable)))
  }
  names(char_sum_list) = var_list
  
  #summary statistics of continous variables
  cont_sum_list = list()
  for (var_i in var_list){
    var_i_loc = grep(var_i, colnames(df_test))
    cont_index2 = append(cont_index,var_i_loc)
    
    df_cont = df_test[,cont_index2]
    mean_result = aggregate(.~ eval(as.name(noquote(var_i))), df_cont, function(x) mean = mean(x))
    sd_result = aggregate(.~ eval(as.name(noquote(var_i))), df_cont, function(x) sd = sd(x))
    
    mean_result = round(t(mean_result),2)
    sd_result = round(t(sd_result),2)
    
    row_name = rownames(mean_result)
    
    n_col = dim(sd_result)[2]
    result_list = list()
    for (i in c(1:n_col)){
      
      col = paste("col",i)
      assign(col, paste(mean_result[,i],"(", sd_result[,i], ")"))
      result_list[[i]] = eval(as.name(col))
      
    }
    result_temp2 = do.call(cbind,result_list)
  
    rownames(result_temp2) = row_name
    result_temp2 = as.data.frame(result_temp2)
    
    p_aov = c()
    for (i in c(1:dim(df_cont)[2])){
      res.aov = aov(df_cont[[i]]~ eval(as.name(noquote(var_i))), data = df_cont)
      res.aov2 = summary(res.aov)
      p = res.aov2[[1]][1,5]
      if (p <0.0001){
        p = "<0.001"
      }
      else{
        p = round(p,3)
      }
      p_aov = rbind(p_aov,p)
    }
    
    result_temp2 = result_temp2[-1,]
    
    result_temp2 = cbind(result_temp2, p_aov)
    result_temp3 = result_temp2[-nrow(result_temp2),]

    
    cont_sum_list = append(cont_sum_list,list(result_temp3))
    
  }
  names(cont_sum_list) = var_list
  
  
  for (var_i in var_list){
    write.xlsx(cont_sum_list[[var_i]],file="continous_summary.xlsx" 
               ,sheetName=var_i
               ,append=T,row.names = T)
  } 
  
  
  for (var_i in var_list){
    write.xlsx(char_sum_list[[var_i]],file="categorical_summary.xlsx" 
               ,sheetName=var_i
               ,append=T,row.names = T)
  } 
  
  
}

#list of variables for subgroup comparisons
var_list = c("var8","var9","var10","var11")

#call the function
dec_tab(var_list)
