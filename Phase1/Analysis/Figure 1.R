## Datasets ---------------------------------
contact<-readRDS('./Phase1/Datasets/contact.rds')

## Packages ---------------------------------
package_list <- c(
  "reshape2",
  "ggplot2",
  "ggpubr",
  "dplyr",
  "tidyverse",
  "kableExtra",
  "gridExtra",
  "RColorBrewer",
  "cowplot",
  "cellranger"
)
if(F){
  install.packages(package_list)
}

invisible(lapply(package_list, function(x) library(x, character.only = T)))

rm(package_list)
## Functions -------------------------
# Function used to save legend of ggplot2 (allows manipulating legend)
get_legend<-function(myggplot){
  tmp <- ggplot_gtable(ggplot_build(myggplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)
}

# Function used to visualize age-specific contact mixing matrix with controls over title, text size, mid and max points for legend and legend position

contactmatrix_viz<-function(matrix1,title,txt_size, mid, max, legendpos){
  ggplot(data = matrix1, aes(x=factor(age_cat), y=factor(contact_age), fill=avg_cont)) +    ##var1 is age of person, var2 is age of contact
    geom_raster(hjust = 0.5, vjust = 0.5,show.legend=T)+
    scale_fill_gradient2(low = "white", high = "#273871", mid = "#7FABD3", midpoint = mid, limit = c(0,max))+
    xlab("Age of participant")+ylab("Age of contact")+labs(fill = "Average \ncontact")+
    theme_classic()+
    theme(plot.title = element_text(size = 12), legend.title=element_text(size = 10),
          axis.text.x = element_text(size = 10), # changed from txt_size (MK)
          axis.text.y = element_text(size= 10),
          legend.justification = "right",
          legend.position = legendpos) +
    ggtitle(title)
}

## Variable Creation -----------------------

contact$loc <- NA
contact <- contact %>% mutate(
  loc = ifelse(cont_home == "1", "home",
               ifelse(cont_otherhome == "1", "other_home",
                      ifelse(street == "1"|store == "1", "street_store",
                             ifelse(work=="1", "work", "other")))))

unique<- nrow(contact) - (nrow(subset(contact, diaryday=="Second day" & contact_fromdayone == "Yes")))*2  # calculate unique by subtracting double of duplicates from day two from total number of contacts
repeated <- nrow(subset(contact, diaryday=="Second day" & contact_fromdayone == "Yes"))*2   #self reported repeats from day 2 multipled by 2


df <- rbind(data.frame(value = c("unique","repeated"), n = c(unique,repeated)) %>% mutate(prop=round((n/sum(n))*100,digits=2), var=rep("Repeated")),
            contact %>% group_by(loc) %>% summarize(n=n()) %>% mutate(prop=round((n/sum(n))*100,digits=2), var=rep("Location")) %>% dplyr::rename(value = loc),
            contact %>% group_by(cont_attr) %>% summarize(n=n()) %>% mutate(prop = round((n/sum(n))*100,digits=2),var=rep("Proximity"))  %>% dplyr::rename(value = cont_attr),
            contact %>% group_by(totaltime) %>% summarize(n=n()) %>% mutate(prop = round((n/sum(n))*100, digits =2 ), var=rep("Duration")) %>% dplyr::rename(value = totaltime))%>% 
  mutate(value1 = c("Unique","Repeated","Home","Other","Other's home","Street/Store","Work","Conv.Only","Conv & Phys","Phys.Only", "1-4 hrs","15mins -1hr","5-15 mins","< 5 mins",">4 hrs",NA),
         value1=as.factor(value1),
         value1= ordered(value1, levels= c("< 5 mins","5-15 mins","15mins -1hr","1-4 hrs",">4 hrs",
                                           "Other's home","Work","Other","Street/Store","Home",
                                           "Unique","Repeated",
                                           "Conv.Only","Phys.Only","Conv & Phys")),
         col = c("1","5","1","2","3","4","5","1","2","3","1","2","3","4","5","5"))


mypal <- c(brewer.pal (n = 5, name = "Purples"),
           brewer.pal(n = 5, name = "Blues"),
           brewer.pal(n=9, name="Greys")[c(2,4)],
           brewer.pal (n=9, name = "BuGn")[c(1,3,8)])

## Figure 1: Distribution of contacts by contact attribute ----
ggplot(df, aes(x=var,y=prop, fill=value1)) +
  geom_col(aes(fill=value1)) +
  geom_text(aes(label = value1),
            size = 3.5,
            position = position_stack(vjust = .5))+
  ylab("% of all contacts") + xlab("Contact attribute") +
  ggtitle("A. Distribution of contacts by contact attribute")+
  scale_fill_manual(values = mypal) + 
  theme_classic()+
  theme(plot.title = element_text(size = 12),
        axis.text.x = element_text(size=10),
        axis.text.y = element_text(size=10),
        legend.position= "none" )
