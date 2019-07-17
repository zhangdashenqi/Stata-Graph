
			************************************************
			****				Stata之禅				****
			****			the Zen of Stata			****
			************************************************

*=============================
*-处理离群值
*=============================

*-1.了解你的数据

*-2.缩尾处理(winsorize)

* 	2.1 标准差倍数
* 	将位于[mean - n * sd, mean + n * sd]之外的值替换为边界值

cap program drop winsor_sd	
program def winsor_sd, sortpreserve
	version 15.0
	syntax varname [if] [in] [, N(real 3.0) Generate(str)]
	
	// 确认要生成的新变量是否存在
	cap confirm new variable `generate'  	// 捕获异常
	if _rc{ 								// 处理异常
		dis as err "generate() should give new variable name"
		exit _rc
	}
	
	// 标记将要winsor的样本
	marksample touse
	
	// 获取变量的均值与标准差
	qui sum `varlist' if `touse'
	local mean = r(mean)
	local sd = r(sd)
	local low = `mean' - `n' * `sd'
	local high = `mean' + `n' * `sd'
	
	// 进行缩尾
	clonevar `generate' = `varlist'
	qui replace `generate' = `low' if `touse' & `generate' < `low'
	qui replace `generate' = `high' if `touse' & `generate' > `high'
end

sysuse nlsw88.dta, clear
winsor_sd wage, g(wage_wsd)

* 	2.2 绝对界限
* 	将位于某一绝对范围外的值替换为边界值

cap program drop winsor_range	
program def winsor_range, sortpreserve
	version 15.0
	syntax varname [if] [in] , Range(numlist min=2 max=2) Generate(str)
	
	// 判断给定的范围是否超出变量的最大最小值
	tokenize "`range'"
	local low = `1'
	local high = `2'
	qui sum `varlist'
	local min = r(min)
	local max = r(max)
	if (`low'>`high')|(`low'<`min')|(`high'>`max'){
		dis as err "range() error, please check it"
		exit
	}
	
	// 确认要生成的新变量是否存在
	cap confirm new variable `generate'  	// 捕获异常
	if _rc{ 								// 处理异常
		dis as err "generate() should give new variable name"
		exit _rc
	}
	
	// 标记将要winsor的样本
	marksample touse
	
	// 进行缩尾
	clonevar `generate' = `varlist'
	qui replace `generate' = `low' if `touse' & `generate' < `low'
	qui replace `generate' = `high' if `touse' & `generate' > `high'
end

winsor_range wage, range(2 30) g(wage_wrg)

winsor wage, h(5) gen(wage_wh5)  // 使用winsor命令，对头尾5个值进行缩尾

* 	2.3 分位数界限
* 	将位于某一分位数范围外的值替换为边界值

winsor wage, p(0.01) gen(wage_wq1)

/*
winsor2 wage, cut(1 99) s(_wq1)  // 使用winsor2命令，结果同上
*/


*	2.4 中位数缩尾
*	将位于[med - n * distance, med + n * distance]之外的值替换成边界值

cap program drop winsor_med	
program def winsor_med, sortpreserve
	version 15.0
	syntax varname [if] [in] [, N(real 3.0) Generate(str)]
	
	// 确认要生成的新变量是否存在
	cap confirm new variable `generate'  	// 捕获异常
	if _rc{ 								// 处理异常
		dis as err "generate() should give new variable name"
		exit _rc
	}
	
	// 标记将要winsor的样本
	marksample touse
	
	// 获取变量的中位数
	_pctile `varlist'
	local med = r(r1)
	
	// 生成临时变量var1
	tempvar var1
	gen `var1' = abs(`varlist' - `med')
	
	// 获取distance
	_pctile `var1'
	local distance = r(r1)
	
	// 进行缩尾	
	local low = `med' - `n' * `distance'
	local high = `med' + `n' * `distance'
	
	clonevar `generate' = `varlist'
	qui replace `generate' = `low' if `touse' & `generate' < `low'
	qui replace `generate' = `high' if `touse' & `generate' > `high'
end


winsor_med wage, g(wage_wmd)

sum wage*, sep(6)

*-3.截尾处理
*	将超出范围的值替换为缺失值（.）

/*
replace `generate' = . if `touse' & `generate' < `low'
replace `generate' = . if `touse' & `generate' > `high'
*/


