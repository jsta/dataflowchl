source("/home/jose/Documents/Science/Data/ENP_MMN/R/update_mmndbhydro.R")

legacypath <- file.path("/home", "jose", "Documents", "Science", "Data", "ENP_MMN", "legacy", "SFER_Data_Thru_April2015.csv")
dbhydt <- update_mmn(legacypath = legacypath, tofile = FALSE, update = FALSE)

write.csv("/home/jose/Documents/Science/JournalSubmissions/DataflowChl/data/dbhydt.csv",row.names = FALSE)

