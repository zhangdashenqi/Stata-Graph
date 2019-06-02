
			************************************************
			****				Stata之禅				****
			****			the Zen of Stata			****
			************************************************

* Pivotable 1

import excel "机构退出列表.xls", sheet("许可证情况导出") firstrow clear
drop 经度 纬度 机构地址
gen year = yofd(date(批准成立日期, "YMD")) 		// 银行分支机构成立年份
gen quit_year = yofd(date(发生日期, "YMD"))  	// 银行分支机构退出年份
gen age = quit_year - year + 1 					// 存续时间

*=collapse==

* 按省份统计
collapse (count) banknum = 流水号, by(省份)

collapse (count) banknum = 机构名称, by(省份)

* 按时间统计


collapse (count) banknum = 流水号, by(year)

* 按省份和时间统计

collapse (count) banknum = 流水号, by(省份 year)


* 平均

collapse (mean) bank_mean = banknum ///
		 (sum)  bank_sum  = banknum if year>=2008, by(year)


*=tabstat=
tabstat 流水号, by(省份) s(n) 

bysort year: tabstat 流水号, by(省份) s(n) 

	