
			************************************************
			****				Stata之禅				****
			****			the Zen of Stata			****
			************************************************
			
*-Stata绘图之twoway area（一）


*-五边形
clear
set obs 6
gen theta = 1 * (_n - 1) * (2*_pi)/5
gen x = sin(theta)
gen y = cos(theta)

twoway area y x , xsize(10) ysize(10) color(yellow) nodropbase


*-五芒星
clear
set obs 6
gen theta = 2 * (_n - 1) * (2*_pi)/5
gen x = sin(theta)
gen y = cos(theta)

twoway area y x , xsize(10) ysize(10) color(yellow) nodropbase

*-七边形
clear
set obs 8
gen theta = 1 * (_n - 1) * (2*_pi)/7
gen x = sin(theta)
gen y = cos(theta)

twoway area y x , xsize(10) ysize(10) color(yellow) nodropbase


*-七芒星
clear
set obs 8
gen theta = 2 * (_n - 1) * (2*_pi)/7
gen x = sin(theta)
gen y = cos(theta)

twoway area y x , xsize(10) ysize(10) color(yellow) nodropbase

*-七芒星
clear
set obs 8
gen theta = 3 * (_n - 1) * (2*_pi)/7
gen x = sin(theta)
gen y = cos(theta)

twoway area y x , xsize(10) ysize(10) color(yellow) nodropbase 

*-八芒星
clear
set obs 9
gen theta = 5 * (_n - 1) * (2*_pi)/8
gen x = sin(theta)
gen y = cos(theta)

twoway area y x , xsize(10) ysize(10) color(yellow) nodropbase 


*-十三芒星
forvalues i = 1(1)6{
	clear
	set obs 14
	gen theta = `i' * (_n - 1) * (2*_pi)/13
	gen x = sin(theta)
	gen y = cos(theta)

	twoway area y x , xsize(10) ysize(10) color(yellow) nodropbase
	graph save graph`i', replace
}
graph combine graph1.gph graph2.gph graph3.gph ///
			  graph4.gph graph5.gph graph6.gph
