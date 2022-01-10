DECLARE @db NVARCHAR(256);

DECLARE @query NVARCHAR(max);
DECLARE @step INT = 1;
DECLARE @dbnameQuery NVARCHAR(256);

DECLARE @dbs TABLE (
    id int primary key clustered identity(1,1),
    name nvarchar(256)
)

INSERT INTO @dbs (name)
  select name
  from sys.sysdatabases
  where name != 'master'
    and name != 'tempdb'
    and name != 'model'
    and name != 'msdb'
    and name != '<DBXYZ>'
    /*
      <DBXYZ> is an example of database name
      wanted to be excluded from the list
      where users will be granted on the
      instance
    */
    and name not like '%ABC%'
    /*
      %ABC% is an example of chars included
      in the database name to be excluded
      from the list where users will be
      granted on the instance
    */
    and name not like '%DEF%' -- same that '%ABC%'

WHILE (select max(id) from @dbs) >= @step
  BEGIN
    SET @db = (
      select name
      from @dbs
      where id = @step
    )
    /*
      Simply replace <MYUSER> by
      the user you want to grant
      on databases
    */
    SET @query  = '
      USE ['+@db+'];
      PRINT N''*['+@db+']'';

      IF EXISTS (
        select name 
        from sys.sysusers
        where name = ''<MYUSER>''
      )
      BEGIN
        PRINT N''	Removing user : <MYUSER> from '+@db+';'';
        DROP USER [<MYUSER>];
        PRINT N''	Create user   : <MYUSER>'';
        CREATE USER [<MYUSER>] FOR LOGIN [<MYUSER>];
        ALTER ROLE [db_datareader] ADD MEMBER [<MYUSER>];
        ALTER ROLE [db_datawriter] ADD MEMBER [<MYUSER>];
      END ELSE BEGIN
        PRINT N''	Create user   : <MYUSER> on '+@db+';'';
        CREATE USER [<MYUSER>] FOR LOGIN [<MYUSER>];
        ALTER ROLE [db_datareader] ADD MEMBER [<MYUSER>];
        ALTER ROLE [db_datawriter] ADD MEMBER [<MYUSER>];
      END
    ';

    EXEC sp_executesql @query
    SET @step += 1;
  END
