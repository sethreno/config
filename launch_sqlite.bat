:: create a unique file name
set fileName=sqlite_%time:~0,2%%time:~3,2%%time:~6,2%_%date:~-10,2%%date:~-7,2%%date:~-4,4%.sql

:: write the command to excute to the file for reference
echo -- Query sqlite %1 > %temp%\%fileName%

:: write a query to show all the db objects
echo select type, name from sqlite_master >> %temp%\%fileName%

:: open vim maximized, execute the command, and move it to a small left  pane
start gvim %temp%\%fileName% -c "set lines=999 columns=999" -c "Query sqlite %1" -c "wincmd H" -c "vertical resize 30" -c "wincmd l | :2"

