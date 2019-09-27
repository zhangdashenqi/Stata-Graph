
			************************************************
			****				Stata之禅				****
			****			the Zen of Stata			****
			************************************************

*==============================
*-Stata绘图之function
*==============================

twoway function y = ln(x/(1-x))

twoway function y = x^2, range(-1 1) horizontal

twoway function y = tden(4,x), range(-4 4) || ///
function y = normalden(x), range(-4 4)


twoway function y = tden(4,x), range(-4 4) || ///
	function y = normalden(x), range(-4 4)    ///
	legend(label(1 "t分布(df=4)")     ///
		   label(2 "正态分布"))


twoway function y = normalden(x), range(-4 4) dropline(-1.96 1.96)


twoway function y=exp(-x/6)*sin(x), range(0 12.57)

#delimit ;
	twoway (function y=normalden(x), 
				range(-4 -1.96) color(gs12) recast(area))
		   (function y=normalden(x),
				range(1.96 4)   color(gs12) recast(area))
		   (function y=normalden(x),
				range(-4 4) lstyle(foreground)),
		ysca(off) xsca(noline)
		xlabel(-4 "-4 sd" -3 "-3 sd" -2 "-2 sd" -1 "-1 sd" 0 "mean"
				1 "1 sd" 2 "2 sd" 3 "3 sd" 4 "4 sd", grid gmin gmax)
		xtitle("")
		scheme(s1mono)
		legend(off)
		;
#delimit cr

local func "x^4 * sin(1/x)^2"
twoway function y = `func', range(-2 2)

local func "x^4 * sin(1/x)^2"
twoway function y = `func', range(-0.2 0.2)

local func "x^4 * sin(1/x)^2"
twoway function y = `func', range(-0.1 0.1)

local func "x^4 * sin(1/x)^2"
twoway function y = `func', range(-0.04 0.04)

local func "x^4 * sin(1/x)^2"
twoway function y = `func', range(-0.01 0.01)

local func "x^4 * sin(1/x)^2"
twoway function y = `func', range(-0.001 0.001)


local func "1/36 * exp(-(36*x - 36/2.7183)^4) - 1.5*x*log(x)"
#delimit ;
	twoway function y = `func', 
		horizontal
		ysize(4)
		xsize(3)
		xtitle("")
		ytitle("")
		xlabel(0(0.1)0.6, grid)
		ylabel(0(0.1)1, grid)
		scheme(s1mono)
	;
#delimit cr
