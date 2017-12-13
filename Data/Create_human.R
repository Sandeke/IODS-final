# Name: Kevin Sandeman
# Email: kevin_sandeman@yahoo.se
# Date: 10/12/2017
# Description: Human dataset of United Nations Development Programme
# Wrangling from excercise 4 and 5 combined, according to the instructions of the course.

#Read the "Human development" and "Gender inequality" datas into R

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

#Structure, dimensions and summaries of the variables are checked.

dim(hd)
str(hd)
summary(hd)
dim(gii)
str(gii)
summary(gii)


#New columnnames are made.

colnames(hd) <- c("HDI.Rank", "Country", "HDI", "Life.Exp", "Edu.Exp", "Edu.Mean", "GNI", "GNI.Minus.Rank")
colnames(gii) <- c("GII.Rank", "Country","GII", "Mat.Mort", "Ado.Birth", "Parli.F", "Edu2.F", "Edu2.M", "Labo.F", "Labo.M")

#New variable ratios of Female and Male populations within secondary education and labour force participation are calculated.

gii$Edu2.FM <- gii$Edu2.F / gii$Edu2.M
gii$Labo.FM <- gii$Labo.F / gii$Labo.M

#Join the data sets by country.

library(dplyr)
human <- inner_join(hd, gii, by = "Country")
str(human)

#Save data

setwd("C:/Users/kevin/Dropbox/IODScourse/IODS-final/Data")
write.table(human, file = "human.csv", sep = ",", col.names = TRUE, row.names = FALSE)

# Read and check data

human <- read.table("human.csv", header = TRUE, sep = ",")
str(human)


# Mutate GNI variable to numeric as there is a comma.

library(stringr)
library(dplyr)

human <- mutate(human, GNI = str_replace(human$GNI, pattern = ",", replace = "") %>% as.numeric())
human$GNI

# Keep only certain variables:"Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mort", "Ado.Birth", "Parli.F".

keep <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mort", "Ado.Birth", "Parli.F")

# select the 'keep' columns

human <- dplyr::select(human, one_of(keep))

# print out a completeness indicator of the 'human' data

complete.cases(human)

# filter out all rows with non available values

human <- filter(human, complete.cases(human))

#  look at the last 10 observations of human

tail(human, 10)

# define the last indice we want to keep, choose everything until the last 7 observations/ these are not countries

last <- nrow(human) - 7

# Keep all data rows, except for the last 7.

human <- human[1:last, ]

# Row names of the data by the country names.

rownames(human) <- human$Country
rownames(human)

# Remove the country name column from the data.

human$Country <- NULL

# Add new variable to dichotomize group and factorize parameter (reference in repository)
human$High.Mat.Mort <-ifelse(human$Mat.Mort>70,"TRUE","FALSE")
#human$High.Mat.Mort <- factor(human$High.Mat.Mort)
str(human)
glimpse(human)

# Save file and overwrite first one
setwd("C:/Users/kevin/Dropbox/IODScourse/IODS-final/Data")

write.table(human, file = "human.csv", sep = ",", col.names = TRUE, row.names = TRUE)
human <- read.csv(file="human.csv", header = TRUE, row.names = 1)
str(human)
