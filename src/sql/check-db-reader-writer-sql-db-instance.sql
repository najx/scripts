/*
  Ensure the user <SQL_USER> has db_reader & db_writer access
  to a database on SQL Server (v2016 at least)
    (Should work with v2012, v2008 but not tested)
*/

DECLARE @db          NVARCHAR(256);

DECLARE @query       NVARCHAR(max);
DECLARE @step        INT = 1;
DECLARE @dbnameQuery NVARCHAR(256);

DECLARE @dbs TABLE (
  id int primary key clustered identity(1,1),
  name nvarchar(256)
)

/*
/ This is the list of databases
/ used to interate
*/

INSERT INTO @dbs (name)
  VALUES
    ('<DATABASE1>'),
    ('<DATABASE2>'),
    ('<DATABASE3>');

/*
/ When you can to check the rights
/ in all databases of an instance

  INSERT INTO @dbs (name)
    select name
    from sys.sysdatabases
    where name != 'master'
      and name != 'tempdb'
      and name != 'model'
      and name != 'msdb'
      and name != '<DBTOEXCLUDE>'
      and name NOT LIKE '%DBTOEXCLUDE%'
*/

WHILE (select max(id) from @dbs) >= @step
  BEGIN
    SET @db = (
      select name
      from @dbs
      where id = @step
    )
    SET @query  = '
      USE ['+@db+'];
      DECLARE @val INT = 0;

      SET @val = (
        select uid
        from sys.sysusers
        where name = ''<SQL_USER>''
      )
      --PRINT @val;

      IF EXISTS (
        select *
        from sys.database_role_members
        where (role_principal_id = ''16390'' or role_principal_id = ''16391'') and member_principal_id = @val
      )
      BEGIN
        PRINT ''ok on     '+@db+''';
      END
      ELSE
      BEGIN
        PRINT ''not ok on '+@db+''';
        -- ALTER ROLE [db_datareader] ADD MEMBER [<SQL_USER>];
        -- ALTER ROLE [db_datawriter] ADD MEMBER [<SQL_USER>];

        -- -> Do not remove comment if the purpose is just to check...
        -- -> Uncomment if you need to fix the rights for the user <SQL_USER>...
      END
    '

    EXEC sp_executesql @query
    SET @step += 1;

  END
