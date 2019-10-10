
			************************************************
			****				Stata之禅				****
			****			the Zen of Stata			****
			************************************************
			
*-Stata绘图之twoway area（二）：绘制国旗

clear
set obs 100
gen x = .
gen y = .
gen _ID = .

*-红色背景
replace x = -15 in 1
replace y =  10 in 1
replace x =  15 in 2
replace y =  10 in 2
replace x =  15 in 3
replace y = -10 in 3
replace x = -15 in 4
replace y = -10 in 4
replace x = -15 in 5
replace y =  10 in 5
replace _ID = 1 in 1/5

*-大五角星（中心点(-10, 5),半径为3）
forvalues i = 1/6{
	local theta = (`i' - 1) * 4 * _pi / 5
	local k = `i' + 6
	
	replace x = 3*sin(`theta') - 10 in `k'
	replace y = 3*cos(`theta') + 5  in `k'
}
replace _ID = 2 in 6/12

*-第一颗小五角星（中心点(-5, 8), 半径为1）
forvalues i = 1/6{
	local theta = (`i' - 1) * 4 * _pi / 5 - (_pi - atan(5/3))
	local k = `i' + 13
	
	replace x = sin(`theta') - 5 in `k'
	replace y = cos(`theta') + 8  in `k'
}
replace _ID = 3 in 13/19

*-第二颗小五角星（中心点(-3, 6), 半径为1）
forvalues i = 1/6{
	local theta = (`i' - 1) * 4 * _pi / 5 - (_pi - atan(7))
	local k = `i' + 20
	
	replace x = sin(`theta') - 3 in `k'
	replace y = cos(`theta') + 6  in `k'
}
replace _ID = 4 in 20/26

*-第三颗小五角星（中心点(-3, 3), 半径为1）
forvalues i = 1/6{
	local theta = (`i' - 1) * 4 * _pi / 5 - atan(7/2)
	local k = `i' + 27
	
	replace x = sin(`theta') - 3 in `k'
	replace y = cos(`theta') + 3  in `k'
}
replace _ID = 5 in 27/33

*-第四颗小五角星（中心点(-5, 1), 半径为1）

forvalues i = 1/6{
	local theta = (`i' - 1) * 4 * _pi / 5 - atan(5/4)
	local k = `i' + 34
	
	replace x = sin(`theta') - 5 in `k'
	replace y = cos(`theta') + 1  in `k'
}
replace _ID = 6 in 34/40


*-绘制区域图
#delimit ;
	twoway (area y x if _ID==1, color(red))
		   (area y x if _ID==2, color(yellow))
		   (area y x if _ID==3, color(yellow))
		   (area y x if _ID==4, color(yellow))
		   (area y x if _ID==5, color(yellow))
		   (area y x if _ID==6, color(yellow)),
	xsize(15) ysize(10) 		// 设置图形尺寸
	xlabel(none) ylabel(none)	// 不显示轴标签
	xtitle("") ytitle("") 		// 不显示轴名称
	legend(off) scheme(s1color) // 关闭图例
	;
#delimit cr

*-添加cmiss()选项
#delimit ;
	twoway (area y x if _ID==1, cmiss(n) color(red))
		   (area y x if _ID>=2, cmiss(n) color(yellow)),
		xsize(15) ysize(10) 
		xlabel(none) ylabel(none)
		xtitle("") ytitle("") 
		xscale(off) yscale(off) // 不显示坐标轴
		graphr(margin(zero)) 	// 图形区Margin为0
		plotr(margin(zero)) 	// 绘图区Margin为0
		legend(off) scheme(s1color)
	;
#delimit cr

*-绘制线图
#delimit ;
	twoway (line y x,  cmiss(n) lcolor(black))
		   (pci 5 -10 8 -5, lcolor(gray))
		   (pci 5 -10 6 -3, lcolor(gray))
		   (pci 5 -10 3 -3, lcolor(gray))
		   (pci 5 -10 1 -5, lcolor(gray))
		   (pcarrowi -10 0 10 0  (8)  "Y"
					 0 -15 0 15  (11) "X", 
					 headlabel lcolor(black)) // 绘制坐标轴
		   (pcarrowi 7 -13 5 -10 (12) "(-10, 5)"
				     9 -3  8 -5  (3)  "(-5, 8)"
				     6 -1  6 -3  (3)  "(-3, 6)"
				     3 -1  3 -3  (3)  "(-3, 3)"
				     0 -3  1 -5  (3)  "(-5, 1)") // 添加五角星中心坐标
		,
		xsize(15) ysize(10)	xscale(off) yscale(off)
		xlabel(-15(1)15, grid) ylabel(-10(1)10, grid ang(0))
		xtitle("") ytitle("") legend(off)
	;
#delimit cr

