import excel "C:\Users\nik596\Documents\GitHub\NBER\SI_participants.xlsx", clear firstrow
drop A 
rename participantlink authorlink

preserve
keep if authorlink ==""
duplicates drop Name, force
replace PaperInNBER = 0
rename Name focal_author
rename authorlink focal_authorlink
drop Affiliation
tempfile nolink 
save `nolink'
restore 

keep if authorlink !=""
replace authorlink = "/people/jonathan_hall1" if authorlink == "/people/jonathan_hall"
duplicates tag Workshop Name,gen(tag)
drop if authorlink == "/people/jonathan_hall1" & Affiliation =="Uber" & tag == 1
drop tag
duplicates drop authorlink, force

* FIND THEIR WP
preserve 
import delimited "C:\Users\nik596\Documents\GitHub\NBER\NBER_WP_long.csv", clear
*rename author Name
tempfile NBER_long 
save `NBER_long'
restore 

merge 1:m authorlink using `NBER_long'
drop count
sort Conference Workshop Name
keep if _m == 3 
drop _m

keep Conference Workshop author authorlink paper_link member PaperInNBER num_authors 

* FIND THEIR CO-AUTHORS
preserve 
import excel "C:\Users\nik596\Documents\GitHub\NBER\NBER_WP.xlsx", firstrow clear
tempfile NBER 
save `NBER'
restore 

merge m:1 paper_link using `NBER'
keep if _m == 3
drop _m 
sort author paper

rename author focal_author 
rename authorlink focal_authorlink
drop papertopic* paperprogram* papergroup* paperproject* authoraddress* A
tostring authorposition* authoraffiliation*, replace
reshape long author authoraffiliation authorlink authorposition, i(focal_authorlink paper_link) j(count)
drop if mi(author)

sort Conference Workshop focal_authorlink papernumber
duplicates drop Conference focal_authorlink papernumber authorlink, force
split papermonth, p(" ")
destring papermonth2, replace 
rename papermonth2 year
rename papermonth1 month

append using `nolink' 
drop Workshop count papermonth
gen conf_year = substr(Conference, -4, 4)
destring conf_year, replace
order conf_year focal_author focal_authorlink papernumber author authorlink num_authors paper
export delimited using "C:\Users\nik596\Documents\GitHub\NBER\SI_co_authorsWP.csv", replace
