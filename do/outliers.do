
			************************************************
			****				Stata之禅				****
			****			the Zen of Stata			****
			************************************************

*=============================
*-寻找离群值
*=============================

*-1. 箱型图

sysuse auto.dta, clear
graph box price, marker(1, mlabel(price))

*-2. 双变量箱型图
*-2.1 根据变量weight

sysuse auto.dta, clear
sum weight
local w_min = r(min)
local w_max = r(max)
gen wei_cat = autocode(weight, 5, `w_min', `w_max') // 生成类别变量
graph box price, over(wei_cat) marker(1, mlabel(price))

*-2.1 根据变量length

sysuse auto.dta, clear
sort length
gen len_cat = autocode(length, 5, length[1], length[_N])
graph box price, over(len_cat) marker(1, mlabel(price))


*-3. 多元变量(bacon)

ssc install bacon   // 安装bacon
help bacon 			// 查看帮助文件

sysuse auto.dta, clear
bacon price weight, gen(wei_bac) p(10) replace
scatter price weight, ml(wei_bac)

bacon price length, gen(len_bac) p(10) replace
scatter price length, ml(len_bac)


hadimvo price weight, gen(wei_hadi) p(10)
scatter price weight, mlabel(wei_hadi)

hadimvo price length, gen(len_hadi) p(10)
scatter price length, mlabel(len_hadi)

bacon price weight length, gen(out_bac) p(10) replace
hadimvo price weight length, gen(out_hadi) p(10)


*-另一个例子

* 箱型图
sysuse nlsw88, clear
graph box wage, over(race)
graph box wage, over(race) over(collgrad)

* 产生tenure的类别变量
sum tenure
local t_min = r(min)
local t_max = r(max)
gen ten_cat = autocode(tenure, 5, `t_min', `t_max')
graph box wage, over(ten_cat)
graph box wage, over(ten_cat) over(collgrad)

* 使用bacon法
bacon wage race collgrad south industry occupation union tenure, ///
	gen(out_bac) p(10)
	

*-参考文献
* [1] Weber, Sylvain. “Bacon: An Effective Way to Detect Outliers 
*	in Multivariate Data Using Stata (and Mata).” 
*	The Stata Journal,vol. 10, no. 3, Sept. 2010, pp. 331–338
* [2] Hadi, A. S. 1992. Identifying multiple outliers in
* 	multivariate data. Journal of the Royal Statistical Society, 
* 	Series B 54: 761–771.
