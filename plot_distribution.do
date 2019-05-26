*========================
* 数据分布特征
*========================

sysuse sp500.dta, replace

gen rr = change / close * 100 	// 收益率
gen dow = dow(date) 			// 星期几

*========================
*-直方图
*========================

histogram rr

* 频数直方图，附加正态分布曲线
histogram rr,bin(20) frequency normal

* 附加均值线
sum rr
local rr_mean : dis %4.3f r(mean)
histogram rr, bin(20) frequency normal  ///
	xline(`rr_mean') fcolor(%50)        ///
	text(40 0 "rr_mean = `rr_mean'", place(east))
	
* by()选项
histogram rr, bin(20) normal by(dow) legend(row(1)) 

* 双变量直方图

help bihist

*========================
*-核密度图
*========================

kdensity rr, normal

* 直方图附加核密度图
twoway histogram rr || kdensity rr
histogram rr, kdensity   // 效果同上

* by()选项
twoway kdensity rr, by(dow)

* 截断时的数据分布
twoway kdensity rr || kdensity rr if rr>0

*========================
* 箱型图
*========================

graph box rr

* by()选项
graph box rr, over(dow)


* 关于四分位间距(the interquartile range, iqr)的介绍，可参考：
help adjacent


