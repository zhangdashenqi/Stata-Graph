
			************************************************
			****				Stata之禅				****
			****			the Zen of Stata			****
			************************************************
*==============================
*-Stata绘图之K线图
*==============================

sysuse sp500.dta, replace
tsset date      // 声明时间序列

gen MA5 = (L4.close + L3.close + L2.close + L.close + close)/5

* K线图的绘制

** 上/下影线的绘制
twoway rspike high low date in 1/50, lc(black)


** 实体的绘制
twoway rbar open close date in 1/50, barw(0.5)

** 黑白实体，阳线为白，阴线为黑
#delimit ;
	twoway (rbar open close date in 1/20 if close>open, 
				barw(0.5) fcolor(gs16) lcolor(gs0))  	// 阳线
		   (rbar open close date in 1/20 if close<=open, 
				barw(0.5) fcolor(gs0)  lcolor(gs0))     // 阴线
		   (rspike high low date in 1/20, 
				lc(black)),  						 	// 影线
		xtitle("")
		ytitle("")
		legend(off)
		scheme(s1mono)
	;
#delimit cr



** 彩色实体，阳线为红，阴线为绿
#delimit ;
	twoway (rspike high low date in 1/50, 
				lc(black))   							// 影线
		   (rbar open close date in 1/50 if close>open, 
				barw(0.5) fcolor(red) lcolor(red)) 		// 阳线
		   (rbar open close date in 1/50 if close<=open, 
				barw(0.5) fcolor(green) lcolor(green)), // 阴线
		xtitle("")
		ytitle("")
		legend(off)
		scheme(s1color)
	;
#delimit cr


* 移动平均线

gen MA5  = (close[_n-4] + close[_n-3] + close[_n-2] +	 ///
			close[_n-1] + close)/5

gen MA10 = (MA5[_n-5] + MA5)/2			
gen MA20 = (MA10[_n-10] + MA10)/2
gen MA30 = (MA10[_n-20] + MA10[_n-10] + MA10)/3
			
tsset, clear	

* K线图		
#delimit ;
	twoway (rspike high low date , 
				lc(black))   							// 影线
		   (rbar open close date if close>open, 
				barw(0.8) fcolor(red) lcolor(red)) 		// 阳线
		   (rbar open close date if close<=open, 
				barw(0.8) fcolor(green) lcolor(green))  // 阴线
		   (line MA5  date , lc(blue))
		   (line MA10 date , lc(yellow))
		   (line MA20 date , lc(purple))
		   (line MA30 date , lc(red))
		   ,
		xtitle("")
		ytitle("")
		xsize(15)
		ysize(5)
		legend(off)
		scheme(s1color)
	;
#delimit cr

graph save stock01.gph, replace

* 成交量
#delimit ;
	twoway (bar volume date if close>open,
				barw(0.8) color(red))
		   (bar volume date if close<=open,
				barw(0.8) color(green)),
		xtitle("")
		ytitle("")
		ylabel(0 "0" 20000 "20K")
		legend(off)
		scheme(s1color)
	;
#delimit cr
graph save stock02.gph, replace



* 加网格

#delimit ;
	twoway (rspike high low date , 
				lc(black))   							// 影线
		   (rbar open close date if close>open, 
				barw(0.8) fcolor(red) lcolor(red)) 		// 阳线
		   (rbar open close date if close<=open, 
				barw(0.8) fcolor(green) lcolor(green))  // 阴线
		   (line MA5  date , lc(blue) lw(vthin))
		   (line MA10 date , lc(yellow) lw(thin))
		   (line MA20 date , lc(purple))
		   (line MA30 date , lc(red))
		   ,
		xtitle("")
		ytitle("")
		xsize(15)
		ysize(5)
		xtick(#50, grid)
		ytick(#10, grid)
		ylabel(, grid gmax)
		xscale(off)
		legend(off)
		scheme(s1color)
	;
#delimit cr	

graph save stock03.gph, replace


* 加成交量
#delimit ;
	twoway (bar volume date if close>open,
				barw(0.8) color(red))
		   (bar volume date if close<=open,
				barw(0.8) color(green)),
		xtitle("")
		ytitle("")
		ylabel(0 "0" 20000 "20K")
		xtick(#50, grid)
		fysize(20)
		legend(off)
		scheme(s1color)
	;
#delimit cr
graph save stock04.gph, replace	

graph combine stock03.gph stock04.gph, ///
	rows(2) scheme(s1color) imargin(0 0 0 0) ysize(6) xsize(16)
