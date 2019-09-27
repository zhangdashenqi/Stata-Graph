
			************************************************
			****				Stata之禅				****
			****			the Zen of Stata			****
			************************************************

*==============================
*-Stata绘图之rarea
*==============================
			
sysuse gnp96.dta, clear
tsset date

/*生成数据*/
gen y0 = gnp96/1000
scalar sigma = 0.01
gen y_u1 = y0 + 0.9*sigma*_n
gen y_d1 = y0 - 0.9*sigma*_n
gen y_u2 = y0 + 2.2*sigma*_n
gen y_d2 = y0 - 2.2*sigma*_n

* 图1 看看数据先
twoway (line y0 date) (line y_u1 date) (line y_d1 date) ///
	   (line y_u2 date) (line y_d2 date)


* 图2 初步
#delimit ;
	twoway (rarea y_u2 y_d2 date)
		   (rarea y_u1 y_d1 date)
		   (line y0 date)
	;
#delimit cr

* 图3 颜色填充

#delimit ;
	twoway (rarea y_u2 y_d2 date,
				lcolor(black*0.1) fcolor(black*0.1))
		   (rarea y_u1 y_d1 date,
				lcolor(black*0.3) fcolor(black*0.3))
		   (line y0 date, lcolor(blue) lwidth(*2)),
		ytitle("")
		xtitle("")
		ylabel(, angle(0))
		xlabel(28(16)156 168)
		legend(off)
		scheme(s1mono)
	;
#delimit cr


* 图4 颜色填充之超越黑白
help colorstyle

#delimit ;
	twoway (rarea y_u2 y_d2 date,
				lcolor(ltblue) fcolor(ltblue))
		   (rarea y_u1 y_d1 date,
				lcolor(midblue) fcolor(midblue))
		   (line y0 date, lcolor(blue) lwidth(*2)),
		ytitle("")
		xtitle("")
		ylabel(, angle(0))
		xlabel(28(16)156 168)
		legend(off)
		scheme(s1color)
	;
#delimit cr



* 图5 另一种区域图area
#delimit ;
	twoway area gnp96 date, 
		color(green%60)
		title("美国实际GNP")
		subtitle("1967-2002")
		ytitle("")
		xtitle("")
		ylabel(0(1000)10000, angle(0) grid)
		xlabel(28(16)156 168, grid)
		legend(off)
		scheme(tufte)
	;
#delimit cr



