###Contact Factoring####
str(contact)
contact$diaryday<-factor(contact$diaryday)
contact$contact_gender<-factor(contact$contact_gender,levels=c("Female", "Male", "I don't know"))
contact$cont_attr<-factor(contact$cont_attr)
contact$totaltime<-factor(contact$totaltime)
contact$cont_home
contact$contact_fromdayone<-factor(contact$contact_fromdayone)
contact_factor$gender<-NULL
contact_factor_factor$cont_home<-as.numeric(contact_factor$cont_home)
contact_factor$street<-as.numeric(contact_factor$street)
contact_factor$store<-as.numeric(contact_factor$store)
contact_factor$cont_otherhome<-as.numeric(contact_factor$cont_otherhome)
contact_factor$work<-as.numeric(contact_factor$work)
contact_factor$school<-as.numeric(contact_factor$school)
contact_factor$worship<-as.numeric(contact_factor$worship)
contact_factor$leisure<-as.numeric(contact_factor$leisure)
contact_factor$transport<-as.numeric(contact_factor$transport)
contact_factor$healthcare<-as.numeric(contact_factor$healthcare)
contact_factor$gym<-as.numeric(contact_factor$gym)
contact_factor$playground<-as.numeric(contact_factor$playground)
contact_factor$loc_other<-as.numeric(contact_factor$loc_other)
saveRDS(contact_factor,file="contact_factor.rds")
####Day Factoring####
str(day)
day_f<-subset(day)
day_f$diaryday<-factor(day_f$diaryday)
day_f$largegroup<-factor(day_f$largegroup)
saveRDS(day_f,file="day_factor.rds")
####Participant Factoring####
str(participant)
participant_factor<-subset(participant)
participant_factor$age_cat<-factor(participant_factor$age_cat)
participant_factor$gender<-factor(participant_factor$gender)
participant_factor$hispanic<-factor(participant_factor$hispanic)
participant_factor$edu<-factor(participant_factor$edu)
participant_factor$hh_str<-factor(participant_factor$hh_str)
participant_factor$state_res2<-factor(participant_factor$state_res2)
saveRDS(participant_factor,file="participant_factor.rds")
