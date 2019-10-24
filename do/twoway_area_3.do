
			************************************************
			****				Stata之禅				****
			****			the Zen of Stata			****
			************************************************

*-Stata绘图之twoway area（三）：绘制地图


*-设置参数
global github "https://raw.githubusercontent.com/zhangdashenqi"
webuse set "${github}/the_zen_of_stata/master/data"

*-载入股票数据
webuse china_map.dta, clear

*-绘制散点
scatter _Y _X, msize(vtiny)

*-绘制一个区域
twoway (area _Y _X if _ID==1, nodropbase)

*-绘制多个区域
#delimit ;
	twoway (area _Y _X if _ID==1, nodropbase)
		   (area _Y _X if _ID==2, nodropbase)
		   (area _Y _X if _ID==3, nodropbase)
		   (area _Y _X if _ID==4, nodropbase)
		   (area _Y _X if _ID==5, nodropbase)
		   (area _Y _X if _ID==6, nodropbase)
		   (area _Y _X if _ID==7, nodropbase)
		   (area _Y _X if _ID==8, nodropbase)
		   (area _Y _X if _ID==9, nodropbase)
	;
#delimit cr


*-绘制全部区域
local cmd ""
forvalues i = 1(1)66{
	local cmd0 "(area _Y _X if _ID==`i', nodropbase)"
	local cmd `cmd' `cmd0'
}
twoway `cmd', legend(off)