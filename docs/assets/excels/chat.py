import xlrd 
import xlwt

workbook = xlrd.open_workbook('./preworknote.xlsx')
sheet = workbook.sheets()[0]
nrows = sheet.nrows
ncols = sheet.ncols
for i in range(0, nrows):
    rowValues = sheet.row_values(i)
    for cell in rowValues:
        print(cell)


