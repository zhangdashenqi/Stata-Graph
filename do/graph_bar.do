
			************************************************
			****				Stata之禅				****
			****			the Zen of Stata			****
			************************************************

*==============================
*-Stata绘图之bar
*==============================

sysuse gnp96.dta, clear  // 美国GNP数据
d                        // 数据描述

tsset date 			 	 // 声明时间序列
gen gnp_r = (gnp96 - L.gnp)/L.gnp * 100
						 // 生成GNP的增长率gnp_r


* 图一
twoway bar gnp96 date, base(4000)

* 图2
twoway bar gnp96 date in 1/10

* 图3
twoway bar gnp96 date in -10/-1

* 图4 barwidth
#delimit ;
	twoway bar gnp96 date in -10/-1,
		barw(0.5)			// 设置条形的宽度为0.5
	;
#delimit cr

* 图5 barlook options

/*
barlook options Description
color(colorstyle) outline and fill color and opacity
fcolor(colorstyle) fill color and opacity
fintensity(intensitystyle) fill intensity
lcolor(colorstyle) outline color and opacity
lwidth(linewidthstyle) thickness of outline
lpattern(linepatternstyle) outline pattern (solid, dashed, etc.)
lstyle(linestyle) overall look of outline
bstyle(areastyle) overall look of bars, all settings above
pstyle(pstyle) overall plot style, including areastyle
*/

* 基本调整
dis tq(1999q1)
dis tq(2002q2)

#delimit ;
	twoway (bar gnp96 date in -14/-1, 
		barw(0.5))
		,
		title("美国实际GNP")
		xtitle("")        	// 设置x轴标题为空
		ytitle("")        	// 设置x轴标题为空
		xlabel(156(2)169, format(%tq))
							// 设置x轴标签为(1999q1-2002q2)
		ylabel(, angle(0))	// 设置y轴标签的角度为0度
		scheme(s1mono)		// 设置风格模板为s1mono
	;
#delimit cr


* 图6 bar的设置
#delimit ;
	twoway (bar gnp96 date in -14/-1, 
		barw(0.5) fi(50) lc(black))
		,                   // 设置条形填充密度和填充颜色
		title("美国实际GNP")
		xtitle("") 
		ytitle("")
		xlabel(156(2)169, format(%tq))
		ylabel(8000(500)10000, angle(0))
		scheme(s1mono)
	;
#delimit cr


* 图7 添加线图

#delimit ;
	twoway (bar gnp96 date in -14/-1, yaxis(1)
		barw(0.5) fi(50) lc(black))
		(line gnp_r date in -14/-1, yaxis(2)
		lc(black))         		// 添加线型图
		,
		title("美国实际GNP")
		xtitle("")  
		ytitle("")
		xlabel(156(2)169, format(%tq))
		ylabel(8000(500)10000, angle(0))
								// 对于2轴的设定
		ylabel(-1(1)3, axis(2) angle(0) format(%2.0f))
		ytitle("", axis(2))
		legend(label(1 "GNP(左)") label(2 "GNP增长率(右)")
			   rows(2) ring(0) pos(11)
			   symxsize(*0.5) size(*0.8))
		scheme(s1color)
	;
#delimit cr
