import excel "C:\Users\nik596\Documents\GitHub\NBER\SI_participants.xlsx", clear firstrow
keep if participantlink !=""
replace participantlink = "/people/jonathan_hall1" if participantlink == "/people/jonathan_hall"
duplicates tag Workshop Name,gen(tag)
drop if participantlink == "/people/jonathan_hall1" & Affiliation =="Uber" & tag == 1
drop tag
rename participantlink authorlink
duplicates drop authorlink, force


preserve 
import delimited "C:\Users\nik596\Documents\GitHub\NBER\NBER_WP_long.csv", clear
*rename author Name
tempfile NBER 
save `NBER'
restore 

merge 1:m authorlink using `NBER'
drop count
sort Conference Workshop Name