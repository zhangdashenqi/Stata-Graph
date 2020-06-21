

cd "D:\git\the_zen_of_stata\data\"

*-数据合并
use 人民币兑美元汇率.dta, clear
gen year = yofd(date)
merge m:1 year using 中国对美出口.dta, nogen

*-贸易值每年只保留第一个
gen tag = 对美出口额[_n] - 对美出口额[_n-1] // 对数据进行差分
replace 对美出口额 = . if tag==0			// 每一年只保留第一个值

*-绘图
twoway 	(bar 对美出口额 date) ///
		(line 人民币兑美元 date, yaxis(2) )



*-图片精装修
format date %tdCCYY
#delimit ;
twoway 	(bar 对美出口额 date, barw(250) lc(black) ) 
		(line 人民币兑美元 date, yaxis(2) lc(black*0.8)),
	xtitle("")
	ytitle("对美贸易余额(十亿美元)")
	ytitle("人民币兑美元(中间价)", axis(2))
	//ylabel(0(50)300)
	xlabel(`=td(1/1/1994)'(735)`=td(1/12/2019)')
	legend(label(1 对美贸易余额) label(2 人民币兑美元中间价)
		   symxsize(*0.5) size(*0.8) ring(0) pos(11))
	xsize(16)
	ysize(9)
	scheme(s1mono)
	;
#delimit cr

