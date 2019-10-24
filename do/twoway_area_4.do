
			************************************************
			****				Stata之禅				****
			****			the Zen of Stata			****
			************************************************

*-Stata绘图之twoway area（四）：另一个类似的命令

clear
set obs 101
gen theta = _n * 2*_pi/100
gen x = sin(theta)
gen y = cos(theta)

insobs 10000 // 插入10000个观察值

// 将一个圆分为n份，然后以每个分割点为圆心画圆
// n尽量要能被360整除，比如18,24,30,36等
local n = 24 
forvalues i = 1(1)`n'{
	local start = `i'*100 + 2*`i' + 1
	local end = `start' + 100
	local x0 = sin(`i'/`n' * 2*_pi)
	local y0 = cos(`i'/`n' * 2*_pi)
	replace theta = (_n - `start' - 1)*2*_pi/100 in `start'/`end'
	replace x = `x0' + sin(theta) in `start'/`end'
	replace y = `y0' + cos(theta) in `start'/`end'
}

twoway (line y x in 102/-1, cmiss(n) nodropbase), xsize(10) ysize(10)


twoway (area y x in 102/-1, cmiss(n) nodropbase ///
	lcolor(black%3) fcolor(black%20)), xsize(10) ysize(10) 

twoway (area y x in 102/-1, cmiss(n) nodropbase ///
	lcolor(black%3) fcolor(green%20)), xsize(10) ysize(10) 
