
			************************************************
			****				Stata之禅				****
			****			the Zen of Stata			****
			************************************************
			
*==============================	
*-用Stata画国旗
*==============================

*-从github载入数据，设置相关参数
global github "https://raw.githubusercontent.com/zhangdashenqi"
webuse set "${github}/Stata-Graph/master/do/graph_flag"

*-载入国旗数据
webuse flag.dta, clear

*-添加国旗红色背景坐标数据
insobs 2
replace x = 1000 in -2
replace y = -667 in -2
replace x = 0    in -1
replace y = -667 in -1

*-绘制国旗
#delimit ;
	twoway (area y x in -2/-1, color(red) base(0) ) // 红色背景
		   (scatter y x in 1/-3, msize(vtiny) mcolor(yellow)), // 黄色星星
		ytitle("")
		xtitle("")
		ylabel(none)
		xlabel(none)
		xsize(10)
		ysize(6.67)
		legend(off)
		scheme(s1color)
	;
#delimit cr