
			************************************************
			****				Stata之禅				****
			****			the Zen of Stata			****
			************************************************


* 画图

* 柱状图

graph bar (count) 流水号, over(quit_year) blabel(total)

gen bank = 1
graph bar (count) bank, over(quit_year) blabel(total)

graph bar (count) bank if (省份=="北京"|省份=="上海"),  ///
	over(quit_year) over(省份) blabel(total)
	
graph bar (count) bank if (省份=="北京"|省份=="上海"),  ///
	over(省份) over(quit_year)  blabel(total)	

collapse (count) banknum = bank, by(quit_year)
twoway bar banknum quit_year, barw(0.5) xlabel(2016(1)2018)

graph bar (mean) age, over(quit_year) blabel(total)



graph hbar (count) bank if (省份=="北京"|省份=="上海"),  ///
	over(quit_year) blabel(total) ytitle("") 			 ///
	bar(1, fcolor(green) fintensity(30)) bargap(5)  	 ///
	by(省份, title("银行分支机构退出情况") 				 ///
			 note("数据来源：中国银行业监督管理委员会")) ///
	scheme(s1color) 
	

* 饼状图

graph pie bank, over(quit_year) plabel(_all percent, format(%4.2f))

graph pie bank, over(quit_year) 							///
	plabel(_all percent, format(%4.2f) color(white)) 		///
	legend(row(3) ring(0) symxsize(*0.5) size(*0.8) pos(1))	///
	scheme(s1color)  										///
	title("银行分支机构退出情况") 							///
	note("数据来源：中国银行业监督管理委员会")

graph pie bank if (省份=="北京"|省份=="上海"), 				///
	over(quit_year) 										///
	plabel(_all name, color(white)) 						///
	by(省份, title("银行分支机构退出情况") 					///
			 note("数据来源：中国银行业监督管理委员会") 	///
			 legend(off))									///	
	scheme(s1color) 


* 点图

graph dot (count) bank, over(quit_year)

graph dot (mean) age (median) age, over(quit_year)

graph dot (mean) age (median) age if (省份=="北京"|省份=="上海"), 	///
	over(省份) over(quit_year)  									///
	marker(1, msymbol(Oh)) marker(2, msymbol(Dh))					///
	title("银行分支结构退出时的年龄")
	
graph dot (mean) age (median) age if (省份=="北京"|省份=="上海"), 	///
	over(quit_year) marker(1, msymbol(Oh)) marker(2, msymbol(Dh)) 	///
	by(省份, title("银行分支结构退出时的年龄") 						///
			 note("数据来源：中国银行业监督管理委员会") 			///
			 legend(off))											///	
	scheme(s1color) 
