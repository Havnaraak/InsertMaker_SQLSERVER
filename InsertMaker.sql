/*Definindo parametrizações de exibição*/
SET NOCOUNT ON
SET ANSI_WARNINGS OFF

/*Declaração de variáveis*/
Declare @ColumnNames Table(ColumnName Varchar(MAX), InternalCode int)
Declare @ColumnInternalCode Int
Declare @ColumnsGet Varchar(MAX)
Declare @ColumnsSet Varchar(MAX)
Declare @TableName Varchar(MAX)
Declare @FinalInsert NVarchar(MAX)

/*Definindo valor das variáveis*/
Set @TableName = ''
Set @ColumnsGet = 'Insert Into ' + Char(13) + Char(10) + '	' + @TableName +' (' + Char(13) + Char(10)
Set @ColumnsSet = ''
Set @ColumnInternalCode = 0

/*Inserindo nome das colunas*/
Insert Into
    @ColumnNames(
        ColumnName,
        InternalCode
    )
Select
    Column_Name,
    Row_Number() Over (Order By Column_Name)
From
	INFORMATION_SCHEMA.COLUMNS
Where
	TABLE_NAME = @TableName


/*Montando Insert*/
While (Select Count(1) from @ColumnNames) > 0
	Begin
		Set @ColumnInternalCode = (Select Max(InternalCode) from @ColumnNames)

		if @ColumnInternalCode > 1
			Begin
				Set @ColumnsGet +=  '	' + (Select ColumnName from @ColumnNames where InternalCode = @ColumnInternalCode) + ',' + Char(13) + Char(10);
				Set @ColumnsSet +=  '	' + (Select ColumnName from @ColumnNames where InternalCode = @ColumnInternalCode) + ' = ' + Char(13) + Char(10);
			End
		if @ColumnInternalCode = 1
			Begin
				Set @ColumnsGet +=  '	' + (Select ColumnName from @ColumnNames where InternalCode = @ColumnInternalCode) + Char(13) + Char(10) + ' )' + Char(13) + Char(10) + 'Values (' + Char(13) + Char(10);
				Set @ColumnsSet +=  '	' + (Select ColumnName from @ColumnNames where InternalCode = @ColumnInternalCode) + ' = ' + Char(13) + Char(10) + ')';
			End
		Delete from @ColumnNames where InternalCode = @ColumnInternalCode
	End

Print @ColumnsGet
Print @ColumnsSet


/*Definindo parametrizações de exibição*/
SET NOCOUNT OFF
SET ANSI_WARNINGS ON

